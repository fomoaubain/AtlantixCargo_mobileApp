import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcabs_driver/BookRide/activities_stepper.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'package:qcabs_driver/model/Routes.dart';
import 'package:qcabs_driver/model/dto/tourne.dart';
import 'package:qcabs_driver/service/service_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../Assets/assets.dart';
import '../../Constante.dart';
import 'package:http/http.dart' as http;


class MyActivitiesPage extends StatefulWidget {

  List<Activities> listActivities = [];
   late Runkey runkey;
  var idTourne ;

  MyActivitiesPage(List<Activities> listActivities,var idTourne, Runkey runkey ){
    this.listActivities= listActivities;
    this.idTourne= idTourne;
    this.runkey= runkey;
  }


  @override
  _MyActivitiesPage createState() => _MyActivitiesPage();
}

class _MyActivitiesPage extends  State<MyActivitiesPage>  {
  late SqliteService _sqliteService;
  Future<void>? _launched;
  ScrollController _scrollController = new ScrollController();
  late List<Activities> objActivities=[],  initListActivities=[];
  late Future<List<Activities>>  listFutureActivities;
  var loading = false;
  var token ;
  late Position position;



  @override
  void initState() {
    super.initState();
    loading = true;
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    listFutureActivities=fetchItem();
  }

  Future<List<Activities>> fetchItem() async {
    initListActivities=widget.listActivities.toList();

    return widget.listActivities.toList();
  }

  Future beginRide(var runId, var scheduleId, ) async{
    final prefs = await SharedPreferences.getInstance();
    var date = Constante.getDateForAPI(DateTime.now());
    var hour= DateTime.now().hour;
    var minute= DateTime.now().minute;
    token = prefs.getString('token');


    print("time : $hour$minute");

    var urlApi= Constante.serveurAdress+"vehicule/assignmentEvent/schedule/$scheduleId/run/$runId";
    Map jsonBody = {
      "starting": true,
      "time": "$hour$minute",
      "date": "$date",
      'gpsPosition':{
        "longitude": position!=null ?position.longitude : 0,
        "latitude":position!=null ? position.latitude : 0,
        "time": position!=null ? DateFormat.Hm().format(position.timestamp!) :"",
        "speed": position!=null ? position.speed :0
      }
    };
    String body = json.encode(jsonBody);
    http.Response response = await http.post(
      Uri.parse(urlApi),
      headers: {
        'Accept': '*/*',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: body,
    );
    print("error : " + response.body);
    return response;

  }




  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context,true);
            }
        ),
      ),
      body: FadedSlideAnimation(
        ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Liste des activitées de la tournée : "+ widget.idTourne,
                style: theme.textTheme.headline5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                widget.listActivities.length.toString() +" activitées sont prévus pour cette tournée ",
                style: theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
              ),
            ),
            Container(
              child:FutureBuilder<List<Activities>>(
                future: listFutureActivities,
                builder: (context, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done) {
                    return Constante.ShimmerSimpleVertical(10);
                  }
                  if(initListActivities.length==0) {
                    return Center(
                        child: Constante.layoutDataNotFound("Aucune activité trouvé")
                    );
                  }
                  if(snapshot.hasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: initListActivities.length,
                        itemBuilder: (context,i){
                          Activities nDataList = initListActivities[i];
                          return buildItem(context, nDataList);
                        }
                    );
                  }
                  // By default, show a loading spinner.
                  return Constante.ShimmerSimpleVertical(10);
                },
              ),
            ),

          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
      bottomNavigationBar: Material(
        color: theme.primaryColor,
        child: InkWell(
          onTap: () {
            Constante.alertPopup(context, "Confirmez le début de la tournée ?", () async {
              Navigator.pop(context);
              EasyLoading.show(status: 'Veuillez patienter...');
              position=(await Constante.determinePosition())!;
              try{
                await beginRide(widget.runkey.runIdentifier, widget.runkey.scheduleIdentifier).then((value) async {
                  EasyLoading.dismiss();
                  print(value.statusCode.toString());
                  print(value.toString());
                  if(value.statusCode == 200){
                   await  _sqliteService.updateItems(widget.idTourne, 1).then((value){
                     print("update :" + value.toString());
                   });
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivitiesStepper(widget.listActivities.toList(), widget.idTourne, widget.runkey)));
                  }else{
                    // print(value.body.toString());
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivitiesStepper(widget.listActivities.toList(), widget.idTourne)));
                    Toast?.show("Echèc du démarage de la tournée",
                      duration: Toast.lengthLong,
                      gravity: Toast.bottom,
                      backgroundColor: Colors.black,
                      textStyle:TextStyle(color: Colors.white),
                    );
                  }
                });
              }
              catch (e) {
              print("erreur : $e");
              EasyLoading.dismiss();
              Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.black,
                textStyle:TextStyle(color: Colors.white),
              );
              }

            });
            //print('called on tap');
          },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                'Commencer la tournée',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }

  Widget buildItem( BuildContext context, Activities item){
    var theme = Theme.of(context);
    String heureDepart= item.departureTime.toString().substring(0,2)+"h"+item.departureTime.toString().substring(2,4);
    String heureFin= item.arrivalTime.toString().substring(0,2)+"h"+item.arrivalTime.toString().substring(2,4);

    String urlImage= item.activityType==3 ?'assets/client_in.jpeg' : 'assets/client_out.jpeg';
    String type= item.activityType==3 ?'EMBARQUEMENT' : 'DEBARQUEMENT';

    String earliestArrivalTime=  item.earliestArrivalTime.toString().substring(0,2)+"h"+item.earliestArrivalTime.toString().substring(2,4);
    String latestArrivalTime=  item.latestArrivalTime.toString().substring(0,2)+"h"+item.latestArrivalTime.toString().substring(2,4);

    return GestureDetector(
      onTap:  () {
        showBarModalBottomSheet(
          context: context,
          expand: false,
          builder: (context) => SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: modalBodyDetails(item),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 80,
            padding:
            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: theme.backgroundColor,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: item.activityType==3? Image.asset(urlImage,width:55 , height: 35,) :  Image.asset(urlImage,width:65 , height: 50,),
                ),
                SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.tripInfo.firstName +" "+item.tripInfo.lastName,
                      style: theme.textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Badge(
                      toAnimate: false,
                      elevation: 1,
                      badgeColor: item.activityType==3 ? Colors.green.shade400: Colors.red.shade400,
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(2),
                      position: BadgePosition.topEnd(top: 0, end: -55),
                      padding: EdgeInsets.all(3),
                      badgeContent: Text(
                        type +" : "+ heureDepart,
                        style: TextStyle(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),

                    ),

                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Badge(
                      toAnimate: false,
                      elevation: 1,
                      badgeColor: Colors.grey.shade300,
                      shape: BadgeShape.circle,
                      borderRadius: BorderRadius.circular(2),
                      position: BadgePosition.topEnd(top: -16, end: -6),
                      badgeContent: Text(
                        "1",
                        style: TextStyle(
                            color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      child: Icon(Icons.accessibility_rounded, color: Colors.black, size: 17,),
                    ),

                  ],
                ),
              ],
            ),
          ),
          ListTile(
            dense: true,
            leading: Icon(
              Icons.location_on,
              color: Colors.grey,
              size: 20,
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Destination : ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)
                  ),
                  TextSpan(
                      text: item.location.municipalityName +", "+ item.location.streetTypeName+
                          " "+item.location.streetName,
                      style: TextStyle(fontSize: 14, color: Colors.black,)

                  ),
                ],
              ),
            ),
            tileColor: theme.cardColor,
          ),
          ListTile(
            leading: Icon(
              Icons.timer_outlined,
              color: Colors.grey,
              size: 20,
            ),
            title:RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Plage horaire : ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)
                  ),
                  TextSpan(
                      text: earliestArrivalTime +" - "+ latestArrivalTime,
                      style: TextStyle(fontSize: 14, color: Colors.black,)

                  ),
                ],
              ),
            ),
            dense: true,
            tileColor: theme.cardColor,

          ),
          SizedBox(height: 12),

        ],
      ),
    );

  }

  Widget modalBodyDetails( Activities item) {
    double heightScreen= MediaQuery.of(context).size.height/2;
    return Container(
      height:  heightScreen,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child:  Column(
          children: [
            Center(
              child: Text("Autres détails sur l'activité",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Divider(),
            SizedBox(height:30,),
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.grey.shade500,
                size: 18,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Constante.textWithIcon("Adresse : ",
                      item.location.streetTypeName +" "+ item.location.streetName+" ("+ item.location.streetTypeCode+")",
                      15),
                  SizedBox(height: 5,),
                  Constante.textWithIcon("Intersection, ",item.location.intersection, 15),
                  SizedBox(height: 5,),
                  Constante.textWithIcon("Code postal : ",item.location.postalCode, 15),

                ],
              ),

            ),

            ListTile(
              leading: Icon(
                Icons.house,
                color: Colors.grey.shade500,
                size: 18,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Constante.textWithIcon("Numéro civique :",item.location.civicNumber, 15),
                  SizedBox(height: 5,),
                  Constante.textWithIcon("Suite : ",item.location.suite, 15),
                  SizedBox(height: 5,),
                  Constante.textWithIcon("Immeuble : ",item.location.building, 15),
                  SizedBox(height: 5,),
                  Constante.textWithIcon("Municipalité : ",item.location.municipalityName, 15),
                  SizedBox(height: 5,),
                  Constante.textWithIcon("Térritoire : ",item.location.territory, 15),

                ],
              ),

            ),

          ],
        ),
      ),
    );



  }



}




