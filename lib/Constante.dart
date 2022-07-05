

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

import 'model/dto/tourne.dart';

 class  Constante {
    // debut coordonnée de connexion b2c
   static const tenant= 'exob2ctapreprod';
   static const  clientId= 'c4ecfd77-dd42-41be-8a92-ec551b93b974';
   static const scope = 'https://exob2ctapreprod.onmicrosoft.com/c69f59a9-6f3d-4337-b6a3-401a12c5ec77/user_impersonation';
   static const redirectUri= 'com.flutter.cabira-driver://oauthredirect';
   static const isB2C = true;
   static const policy= "B2C_1_ApiTransportLogin";
   // fin coordonnée de connexion b2c
   static const String token = '';
  static String serveurAdress= "https://apitransport-preprod.exo.quebec/api/transporteur/v1/";

  static const int numeroVehicule = 6;

   static  List<Tourne> listTourne = [];

  static void gpsPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }


  /// are denied the `Future` will return an error.
  static Future<Position?> determinePosition() async {
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

   static Widget ShimmerSimpleVertical(int itemNumber){
     return Shimmer.fromColors(
       child: ListView.builder(
           itemCount: itemNumber,
           scrollDirection: Axis.vertical,
           shrinkWrap: true,
           physics: ScrollPhysics(),
           itemBuilder: (context,i){
             return Card(
               elevation: 1.0,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(5),
               ),
               child: const SizedBox(height: 100),
             );

           }
       ),
       baseColor: Colors.grey[300]!,
       highlightColor: Colors.grey[100]!,
     );
   }

   static Widget shimmerSimpleVertical(int itemNumber){
     return Shimmer.fromColors(
       child: ListView.builder(
           itemCount: itemNumber,
           scrollDirection: Axis.vertical,
           shrinkWrap: true,
           physics: ScrollPhysics(),
           itemBuilder: (context,i){
             return Card(
               elevation: 1.0,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(16),
               ),
               child: const SizedBox(height: 50),
             );
           }
       ),
       baseColor: Colors.grey[300]!,
       highlightColor: Colors.grey[100]!,
     );
   }

 /*  static Future<bool?> layoutNotInternet( BuildContext context){
     return Alert(
       closeIcon: SizedBox(),
       context: context,
       type: AlertType.warning,
       title: "Wifi non disponible",
       buttons: [
         DialogButton(
           child: Text(
             "Fermer",
             style: TextStyle(color: Colors.white, fontSize: 20),
           ),
           onPressed: (){
             Navigator.pop(context);
           },
           gradient: LinearGradient(colors: [
             Colors.red.shade500,
             Colors.red.shade600
           ]),
         )
       ],
     ).show();
   }*/

   static  Widget layoutNotInternet( BuildContext context, Route route){
     return Container(
       width: 300,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           SizedBox(height: 15),
           Container(
             margin: EdgeInsets.all(5),
             alignment: Alignment.topCenter,
             child: Text(
               "Aucune connexion internet ! ",
               style: TextStyle(
                 color: Colors.black45,
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ),

           SizedBox(height: 2),
           Container(
             alignment: Alignment.center,
             padding: EdgeInsets.symmetric(horizontal: 10),
             child:
             Text(
               "Aucune connexion internet disponible ! Vérifier votre point d'accès ou réessayer.",
               style: TextStyle(
                 color: Colors.black45,
                 fontSize: 9,
                 fontWeight: FontWeight.w600,
               ),

               textAlign: TextAlign.center,
             ),
           ),
           SizedBox(height: 10),
           InkWell(
               onTap: ()  {
                 Navigator.pop(context);
                 Navigator.push(context, route);
               },
               child: Icon(Icons.refresh, size: 40, color: Colors.grey,)
           ),
           SizedBox(height: 15),
         ],
       ),
     );
   }

   static  Widget layoutDataNotFound( String text){
     return Container(
       width: 300,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           SizedBox(height: 15),
           Container(
             margin: EdgeInsets.all(5),
             alignment: Alignment.topCenter,
             child: Text(
               text,
               style:TextStyle(
                 color: Colors.black45,
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ),
         ],
       ),
     );
   }

   static Widget textWithIcon(String title, String value, double taille) {
     return RichText(
       text: TextSpan(
         children: [
           TextSpan(
               text: title,
               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: taille)
           ),
           TextSpan(
               text: value,
               style: TextStyle(fontSize: taille, color: Colors.black,)

           ),
         ],
       ),
     );
   }


   static alertPopup(BuildContext context ,  String? titre, [Function? onTap] ) {
     return Alert(
       closeIcon: SizedBox(),
       context: context,
       type: AlertType.none,
       title: titre,
       buttons: [
         DialogButton(
           child: Text(
             "Non",
             style: TextStyle(color: Colors.white, fontSize: 20),
           ),
           onPressed: () => Navigator.pop(context),
           color: Colors.red.shade500,
         ),
         DialogButton(
           child: Text(
             "Oui",
             style: TextStyle(color: Colors.white, fontSize: 20),
           ),
           onPressed:  onTap as void Function()? ?? () {
            onTap;
           },
           gradient: LinearGradient(colors: [
             Colors.green.shade500,
             Colors.green.shade600
           ]),
         )
       ],
     ).show();
   }


   static bool areListsEqual(var list1, var list2) {
     // check if both are lists
     if(!(list1 is List && list2 is List)
         // check if both have same length
         || list1.length!=list2.length) {
       return false;
     }
     // check if elements are equal
     for(int i=0;i<list1.length;i++) {
       if(list1[i]!=list2[i]) {
         return false;
       }
     }
     return true;
   }


 }