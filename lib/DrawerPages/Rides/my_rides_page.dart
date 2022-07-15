import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import 'my_activities_page.dart';


class MyRidesPage extends StatefulWidget {

  @override
  _MyRidesPage createState() => _MyRidesPage();
}

class _MyRidesPage extends  State<MyRidesPage>  {
  late SqliteService _sqliteService;
  Future<void>? _launched;
  ScrollController _scrollController = new ScrollController();
  late List<Routes> objRoutes=[],  initListRoutes=[];
  late Future<List<Routes>>  listRoutes;
  var loading = false;
  var token ;

  Future<List<Routes>> fetchItem() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    List<Routes> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+'vehicule/runs'),
      headers: {
        'Accept': '*/*',
       "Content-Type": "application/json",
       'Authorization': 'Bearer $token'
      }
    );
    //final String response2 = await rootBundle.loadString('assets/data.json');
    if (response.statusCode == 200) {
      print("code :"+ response.statusCode.toString());
      print("json :"+ response.body);
      final data = await jsonDecode(response.body);
      if (data != null) {
        data.forEach((element) {
          listModel.add(Routes.fromJson(element));
        });
      }
    }

    print("nombre from API : "+listModel.length.toString());
    print("token : "+token);
    initListRoutes=  listModel;
    return listModel.take(20).toList();
  }

  List<Tourne> initListTourne(){
    final List<Tourne> listTourne = [];
    initListRoutes.forEach((element){
      Tourne tourne = new Tourne(idTourne: element.runKey.runIdentifier, status: 0, date_jour: DateTime.now().toString(),);
      listTourne.add(tourne);
    });
    return listTourne;
  }

  Future<Tourne> getTournefromBd( var idTourne) async {
      Tourne? result  = await _sqliteService.getItems(idTourne);
      if(result!=null) {
        print("not null");
      return result;
      }else{
        Tourne tourne = new Tourne(idTourne: idTourne, status: 0, date_jour: DateTime.now().toString());
        await _sqliteService.createItem(tourne);
        print(" null");
        return tourne;
      }
  }
  

 /*Future<List<Routes>> fetchItem() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    List<Routes> listModel = [];
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await jsonDecode(response);
    if (data != null) {
      data.forEach((element) {
        listModel.add(Routes.fromJson(element));
      });
    }
    print("nombre : "+listModel.length.toString());
    print("token : "+token);
    initListRoutes=  listModel;
    return listModel.take(8).toList();
  }*/

/*
  void initSharePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Tourne> listTourne = initListTourne();
    Constante.listTourne = listTourne;
    final String encodedData = Tourne.encode(listTourne);
    // add to sharepreference
    await prefs.setString('current_list_tourne', encodedData);
    // Fetch and decode data
    //final String? jsondata = await prefs.getString('current_list_tourne');
  }

// use this method if listTourne.count>0
  void updateSharePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = Tourne.encode(Constante.listTourne);
    // add to sharepreference
    await prefs.setString('current_list_tourne', encodedData);
    // Fetch and decode data
    final String? jsondata = await prefs.getString('current_list_tourne');
    Constante.listTourne = Tourne.decode(jsondata!);
  }

  void getExistingSharePreferenceData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   if(prefs.containsKey("current_list_tourne")){
     final String? jsondata = await prefs.getString('current_list_tourne');
     var val  = Tourne.decode(jsondata!);

     if( val!=null && val.length>0 && DateTime.parse(val[0].date_jour).day == DateTime.now().day){
       if(Constante.areListsEqual(Constante.listTourne, initListRoutes)==false){
         print("init 3 ");
         initSharePreference();
         return;
       }
       else if( Constante.listTourne.length> 0 && !listEquals( Constante.listTourne, val)){
         print("upddate ");
         updateSharePreference();
       }else{
         print("get ");
         Constante.listTourne= val;
       }
     }else{
       print("init 2 ");
       initSharePreference();
     }
   }else{
     print("init : ");
     initSharePreference();
   }

   /*  final String? jsondata = await prefs.getString('current_list_tourne');
     var val  = Tourne.decode(jsondata!);
     if( val!=null && val.length>0 && val[0].date_jour.day == DateTime.now().day){

     } else{
       initSharePreference();
     }*/

   }


*/
  @override
  void initState() {
    super.initState();
    this._sqliteService= SqliteService();
    this._sqliteService.initializeDB();
    listRoutes= this.fetchItem();
    _scrollController.addListener(_onScroll);


  }

  _onScroll(){
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        loading = true;
      });
      _fetchData();
    }

  }

  Future _fetchData() async {
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {
      objRoutes = initListRoutes.take(objRoutes.length+20).toList();
      loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.getString(Strings.MY_RIDES)!,
                style: theme.textTheme.headline5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                context.getString(Strings.LIST_OF_RIDES_COMPLETED)!,
                style: theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
              ),
            ),
      Container(
        child:FutureBuilder<List<Routes>>(
          future: listRoutes,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.ShimmerSimpleVertical(10);
            }
            if(snapshot.hasError) {
              return Center(
                  child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => MyRidesPage()))
              );
            }
            if(initListRoutes.length==0) {
              return Center(
                  child: Constante.layoutDataNotFound("Aucune tournée trouvé")
              );
            }
            if(snapshot.hasData) {
              if(objRoutes.length==0){
                objRoutes = snapshot.data ?? [];
              }else{
                objRoutes = objRoutes.toList();
              }
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: loading ? objRoutes.length + 1 : objRoutes.length,
                  itemBuilder: (context,i) {
                    if (objRoutes.length == i){
                      return Center(
                          child: CupertinoActivityIndicator()
                      );
                    }
                    Routes nDataList = objRoutes[i];
                    return FutureBuilder<Tourne>(
                      future: getTournefromBd(nDataList.runKey.runIdentifier),
                        builder: (context, userSnapshot) {
                          if(userSnapshot.connectionState != ConnectionState.done) {
                            return Constante.ShimmerSimpleVertical(10);
                          }
                          if(userSnapshot.hasData) {
                            return buildItem(context, nDataList, userSnapshot.data!);
                          }
                          return Constante.ShimmerSimpleVertical(10);
                        }
                    );

                      //return buildItem(context, nDataList);
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
    );
  }

  Widget buildItem( BuildContext context, Routes item, Tourne  tourne){
    var theme = Theme.of(context);

    int nombreActivite = item.activities.length;
    String heureDepart= item.activities[0].departureTime.toString().substring(0,2)+"h"+item.activities[0].departureTime.toString().substring(2,4);
    String heureFin= item.activities[nombreActivite-1].arrivalTime.toString().substring(0,2)+"h"+item.activities[nombreActivite-1].arrivalTime.toString().substring(2,4);

   // print("nombre de tournée  : " + Constante.listTourne.length.toString());
    //getListTournefromBd2(item);
   // Tourne tourne= Constante.listTourne.firstWhere((p) => p.idTourne == item.runKey.runIdentifier);

    Color badgecolor =  Colors.green.shade400;
    String badgeTitle ="A venir";
   if(tourne !=null){
       badgecolor = tourne.status==0 ? Colors.green.shade400 : tourne.status ==1 ? Colors.orange.shade400 : Colors.red.shade400;
       badgeTitle = tourne.status==0 ? "A venir" : tourne.status ==1 ? "En cour..." : "Terminé";
    }

    return GestureDetector(
      onTap: () async {
        //   Navigator.pushNamed(context, PageRoutes.stepperPage),
       if( tourne.status==2){
          Toast?.show("Cette tournée est terminé",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.black,
            textStyle:TextStyle(color: Colors.white),
          );
        }else{
        // var result= await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyActivitiesPage( item.activities, item.runKey.runIdentifier, item.runKey)));

         var result = await Navigator.push(context, MaterialPageRoute(
             builder: (context){
               return MyActivitiesPage( item.activities, item.runKey.runIdentifier, item.runKey);
             }
         ));
         setState(() {
           listRoutes= this.fetchItem();
         });
       }
        // Navigator.pushNamed(context, PageRoutes.rideInfoPage),
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
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/arrived_client.jpeg',width:50 , height: 40,)
                ),
                SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tournée : "+ item.runKey.runIdentifier,
                      style: theme.textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      nombreActivite.toString() + ' activité(s) prévus pour cette tournée',
                      style: theme.textTheme.caption,
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
                      badgeColor:badgecolor,
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(5),
                      position: BadgePosition.topEnd(top: 0, end: -55),
                      padding: EdgeInsets.all(3),
                      badgeContent: Text(
                        badgeTitle,
                        style: TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
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
                      text: "Départ : ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)
                  ),
                  TextSpan(
                      text: item.activities[0].location.municipalityName +", "+ item.activities[0].location.streetTypeName+
                      " "+item.activities[0].location.streetName,
                      style: TextStyle(fontSize: 14, color: Colors.black,)

                  ),
                ],
              ),
            ),
            tileColor: theme.cardColor,
            trailing: Badge(
              toAnimate: false,
              elevation: 0,
              shape: BadgeShape.square,
              badgeColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
              position: BadgePosition.topEnd(top: 0, end: 0),
              padding: EdgeInsets.all(4),
              badgeContent: Text(
                heureDepart,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.navigation,
              color: Colors.grey,
              size: 20,
            ),
            title:RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Arrivée : ",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)
                  ),
                  TextSpan(
                      text: item.activities[nombreActivite-1].location.municipalityName +", "+ item.activities[nombreActivite-1].location.streetTypeName+
                          " "+item.activities[nombreActivite-1].location.streetName,
                      style: TextStyle(fontSize: 14, color: Colors.black,)

                  ),
                ],
              ),
            ),
            dense: true,
            tileColor: theme.cardColor,
            trailing: Badge(
              toAnimate: false,
              elevation: 0,
              shape: BadgeShape.square,
              badgeColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
              position: BadgePosition.topEnd(top: 0, end: 0),
              padding: EdgeInsets.all(4),
              badgeContent: Text(
                heureFin,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );

  }



}




