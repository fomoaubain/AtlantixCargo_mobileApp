import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcabs_driver/DrawerPages/Home/offline_page.dart';
import 'package:qcabs_driver/model/Routes.dart';
import 'package:qcabs_driver/model/dto/client.dart';
import 'package:qcabs_driver/model/dto/tourne.dart';
import 'package:qcabs_driver/service/service_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../Constante.dart';
import 'package:http/http.dart' as http;


class BilanRidesPage extends StatefulWidget {
  List<Customer> listClient = [];
  var idTourne ;
  late Runkey runkey;

  BilanRidesPage(List<Customer> listClient,var idTourne, Runkey runkey){
    this.listClient= listClient;
    this.idTourne= idTourne;
    this.runkey= runkey;
  }

  @override
  _BilanRidesPage createState() => _BilanRidesPage();
}

class _BilanRidesPage extends  State<BilanRidesPage>  {
  late SqliteService _sqliteService;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<Customer> objClient=[],  initListClient=[];
  late Future<List<Customer>>  listClient;
  var loading = false;
  var token;
   TextEditingController _textcontroller = new  TextEditingController();
   var comment="";
  late Position position;

  Future<List<Customer>> fetchItem() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    initListClient=  widget.listClient;
    return widget.listClient.toList();
  }

  Future saveRunCommentAndRun(var runId, var scheduleId, String comment ) async{
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    var date = Constante.getDateForAPI(DateTime.now());
    var hour= DateTime.now().hour;
    var minute= DateTime.now().minute;
    var desc= comment.length==0 ? "Aucun commentaire laisser" : comment;

    var urlApi= Constante.serveurAdress+"vehicule/run/schedule/$scheduleId/run/$runId/comment";
    Map jsonBody = {
      "code": "CM_TOU",
      "desc": "$desc",
      "date": "$date"
    };
    String body = json.encode(jsonBody);

    var urlApi2= Constante.serveurAdress+"vehicule/assignmentEvent/schedule/$scheduleId/run/$runId";
    Map jsonBody2 = {
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
    String body2 = json.encode(jsonBody2);

    var response = await Future.wait([
    http.post(Uri.parse(urlApi),
        headers: {
    'Accept': '*/*',
    "Content-Type": "application/json",
    'Authorization': 'Bearer $token'
    },
    body: body,),

      http.post(Uri.parse(urlApi2),
        headers: {
          'Accept': '*/*',
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: body2,),

    ]);
    int val = response[1].statusCode;
    print(" code : $val" );
    if(response[0].statusCode!=200) return response[0];
    if(response[1].statusCode!=200) return response[1];
    return response[1];
  }

  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    listClient= this.fetchItem();

  }




  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ToastContext().init(context);
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: width,
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                "Bilan de la tournée numéro : "+ widget.idTourne,
                style: theme.textTheme.headline5,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child:FutureBuilder<List<Customer>>(
                future: listClient,
                builder: (context, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done) {
                    return Constante.ShimmerSimpleVertical(10);
                  }
                  if(initListClient.length==0) {
                    return Center(
                        child: Constante.layoutDataNotFound("Aucune donnée trouvé")
                    );
                  }
                  if(snapshot.hasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: initListClient.length,
                        itemBuilder: (context,i){
                          Customer nDataList = initListClient[i];
                          return buildItem(context, nDataList);
                        }
                    );
                  }
                  // By default, show a loading spinner.
                  return Constante.ShimmerSimpleVertical(10);
                },
              ),
            )


          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: theme.primaryColor,
        child: InkWell(
          onTap: () {
            showBarModalBottomSheet(
              backgroundColor: Colors.transparent,
              expand: false,
              context: context,
              isDismissible: false,
              enableDrag: false,
              builder: (context) => SingleChildScrollView(
                controller: ModalScrollController.of(context),
                child: modalCommentaireBody(),
              ),
            );
            },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                'Terminé la tournée',
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

  Widget buildItem( BuildContext context, Customer item){
    var theme = Theme.of(context);
    return GestureDetector(
      child:  ListTile(
        leading: Icon(
          Icons.filter_frames,
          color: Colors.green.shade400,
          size: 20,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Constante.textWithIcon("Nom : ",item.nom+" "+ item.prenom, 15),
            SizedBox(height: 5,),
            Constante.textWithIcon("Payment : ",item.paymentMode.toString(), 15),
            SizedBox(height: 5,),
            Constante.textWithIcon("Activité numéro : ",item.idActivities.toString(), 15),
            SizedBox(height: 5,),
            Constante.textWithIcon("Départ : ", item.depart , 15),
            SizedBox(height: 5,),
            Constante.textWithIcon("Arrivé : ", item.arrive , 15),
            SizedBox(height: 5,),
            Constante.textWithIcon("Etat : ", "terminé" , 15),
            Divider(),
          ],
        ),

      ),
    );

  }


  Widget modalCommentaireBody() {
    double heightScreen= MediaQuery.of(context).size.height;
    return  Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        height: (heightScreen/2),
        padding: EdgeInsets.all(20),
        child:Form(
            key: formKey,
          child: Column(
            children:<Widget>[
              SizedBox(height: 5,),
              Center(
                child: Text("Laisser un commentaire sur cette tournée"  ,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 5,),
              Expanded(
                child: ListView(
                    children: <Widget> [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20,),
                          TextFormField(
                            minLines: 6, // <-- SEE HERE
                            maxLines: 8,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Saisir votre commentaire ici',
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black26)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black26)
                              ),
                            ),
                            validator: (String ? value){
                              comment = value!;
                              return null;
                            },

                          ),

                        ],
                      ),

                    ]
                ),
              ),
              Material(
                shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.blue.shade900,
                child: InkWell(
                  onTap: () async {
                    if(formKey.currentState!.validate()){
                      Navigator.pop(context);
                      print("comment : "+comment);
                      EasyLoading.show(status: 'Veuillez patienter...');

                      try{
                        position=(await Constante.determinePosition())!;
                        await saveRunCommentAndRun(widget.runkey.runIdentifier, widget.runkey.scheduleIdentifier, comment).then((value) async {
                          EasyLoading.dismiss();
                          print(value.statusCode.toString());
                          print(value.toString());
                          if(value.statusCode == 200){
                            await  _sqliteService.updateItems(widget.idTourne, 2).then((value){
                              print("update :" + value.toString());
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OfflinePage()
                                ),
                                ModalRoute.withName("/offline_page")
                            );

                          }else{
                            // print(value.body.toString());
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivitiesStepper(widget.listActivities.toList(), widget.idTourne)));
                            Toast?.show("Impossible de se connecter au serveur veuillez réessayer",
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.black,
                              textStyle:TextStyle(color: Colors.white),
                            );

                          }
                        });
                      }catch(e){
                        EasyLoading.dismiss();
                        Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
                          duration: Toast.lengthLong,
                          gravity: Toast.bottom,
                          backgroundColor: Colors.black,
                          textStyle:TextStyle(color: Colors.white),
                        );

                      }


                    }

                  },
                  child: const SizedBox(
                    height: kToolbarHeight,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Continuer',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ),





    );
  }



}




