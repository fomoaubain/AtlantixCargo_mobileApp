import 'dart:convert';
import 'dart:ffi';


import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:badges/badges.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcabs_driver/BookRide/bilan_ride_page.dart';
import 'package:qcabs_driver/BookRide/map_page.dart';
import 'package:qcabs_driver/DrawerPages/PromoCode/promo_code_page.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:qcabs_driver/model/Routes.dart';
import 'package:qcabs_driver/model/dto/Etape.dart';
import 'package:qcabs_driver/model/dto/client.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:collection/collection.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;

class ActivitiesStepper extends StatefulWidget {

  List<Activities> listActivities = [];

  var idTourne ;
 late Runkey runkey;

  ActivitiesStepper(List<Activities> listActivities,var idTourne,  Runkey runkey ){
    this.listActivities= listActivities;
    this.idTourne= idTourne;
    this.runkey= runkey;
  }

  @override
  _ActivitiesStepper createState() => _ActivitiesStepper();
}

class _ActivitiesStepper extends State<ActivitiesStepper> {

  bool isOpened = true;
  bool rideAccepted = false;
 var  token;
  int activeStep = 0; // Initial step set to 0.
  // OPTIONAL: can be set directly.
   late int dotCount;
   List<int> number = [];
  List<Etape> listEtape = [];
  late  Etape currentEtape = new Etape(id: null, action: null, finish: null);
   late Position position;

 late Activities  activeActivitiesObject;

  List<Customer> listClient = [];

  void initStepper(){
    for(int i=0; i<widget.listActivities.length; i++){
      number.add(i+1);
    }
  }


  Future runActivityComment(var runId, var scheduleId, var activityNo, var code, var desc) async{
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var date = Constante.getDateForAPI(DateTime.now());
    var urlApi= Constante.serveurAdress+"vehicule/run/schedule/$scheduleId/run/$runId/activity/$activityNo/comment";
    Map jsonBody = {
      "code": "$code",
      "desc": "$desc",
      "date": "$date"
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

  Future runActivityEvent(var runId, var scheduleId, var activityNo, Map jsonBody) async{
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    var urlApi= Constante.serveurAdress+"vehicule/runActivityEvent/schedule/$scheduleId/run/$runId/activity/$activityNo";
   var arrivalTime = activeActivitiesObject.arrivalTime;
    var departureTime = activeActivitiesObject.departureTime;

   /* Map jsonBody = {
      "arrivalTime": "$arrivalTime",
      "departureTime": "$departureTime",
      "passengers": [
        {
          "passengerType": 0,
          "paymentMode": "$paymentMode",
          "cardNumber": ""
        }
      ],
      "nbEscorts": 0,
      "confirmArrival": true,
      "date": "2022-07-04T13:11:52.132Z"
    };*/
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
  void initState() {
    super.initState();
    dotCount= widget.listActivities.length-1;
    activeActivitiesObject = widget.listActivities[0];
    initStepper();
    initSharePreference();
  }


  void initSharePreference() async {
    List<Etape> listE = [];
    int count = 0;
    widget.listActivities.forEach((element){
      Etape etape = new Etape(action: 0, finish: false, id: count,);
      listE.add(etape);
      count++;
    });
    listEtape=listE;
    currentEtape = listEtape[0];

    /*final SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = 0;
    widget.listActivities.forEach((element){
      Etape etape = new Etape(action: 0, finish: false, id: count,);
      listE.add(etape);
      count++;
    });
    // Encode and store data in SharedPreferences
    final String encodedData = Etape.encode(listE);

    // add to sharepreference
    await prefs.setString('activities_step', encodedData);
    await prefs.setInt('current_step', activeStep);

    // Fetch and decode data
    final String? jsondata = await prefs.getString('activities_step');
      listEtape = Etape.decode(jsondata!);
      print(listEtape.length);
      activeStep =  0;
      print(activeStep);
      currentEtape = listEtape[0];*/
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    ToastContext().init(context);
    double width= MediaQuery.of(context).size.width;
    double heightScreen= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title:
        Text((activeStep+1).toString()+" sur "+ (dotCount+1).toString(),
          style: Theme.of(context).textTheme.headline6,
        ) ,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget> [
                //previousButton(),
                Expanded(
                  child: NumberStepper(
                    enableNextPreviousButtons: false,
                    nextButtonIcon: Icon(Icons.arrow_right, color: Colors.grey, size: 27,),
                    previousButtonIcon: Icon(Icons.arrow_left_sharp, color: Colors.green, size: 27,),
                    activeStepColor: Colors.blue.shade900,
                    numbers: number,
                    direction: Axis.horizontal,
                    enableStepTapping: false,
                    stepPadding: 15,
                    stepRadius: 4,
                    activeStep: activeStep,
                    onStepReached: (tappedDotIndex) {
                      setState(() {
                        activeStep = tappedDotIndex;
                        print("current step : $activeStep");
                        activeActivitiesObject= widget.listActivities[activeStep];

                      });
                    },
                  ),
                  // Your column
                ),
              //  nextButton()
              ],
            ),


            Expanded(child:
            Content(),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100
              ),
              width: width,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget> [

                  activeActivitiesObject.activityType==3 ? embarquementCardBuild(): debarquementCardBuild(),

                  buildCard( setIcon(Icons.messenger, Colors.orange.shade400) , "Signaler un evènement",
                        () {
                      showBarModalBottomSheet(
                        context: context,
                        expand: true,
                        builder: (context) => SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: modalBodyEvenement(),
                        ),
                      );
                    },
                  ),

                  buildCard(setIcon(Icons.location_on, Colors.red.shade400),"Géolocaliser ma destination",
                      () async {
                        position=(await Constante.determinePosition())!;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage( new LatLng(activeActivitiesObject.location.latitude, activeActivitiesObject.location.longitude), new LatLng(position.latitude, position.longitude) )));
                      }
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  /// Generates jump steps for dotCount number of steps, and returns them in a row.
  Row steps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(dotCount, (index) {
        return ElevatedButton(
          child: Text('${index + 1}'),
          onPressed: () {
            setState(() {
              activeStep = index;
            });
          },
        );
      }),
    );
  }

  /// Returns the header wrapping the header text.
  Widget Content() {
    var theme = Theme.of(context);
    double width= MediaQuery.of(context).size.width;
    double heightScreen= MediaQuery.of(context).size.height;
    String heureDepart= activeActivitiesObject.departureTime.toString().substring(0,2)+"h"+activeActivitiesObject.departureTime.toString().substring(2,4);
    String heureFin= activeActivitiesObject.arrivalTime.toString().substring(0,2)+"h"+activeActivitiesObject.arrivalTime.toString().substring(2,4);

    String urlImage= activeActivitiesObject.activityType==3 ?'assets/client_in.jpeg' : 'assets/client_out.jpeg';
    String type= activeActivitiesObject.activityType==3 ?'EMBARQUEMENT' : 'DEBARQUEMENT';

    String earliestArrivalTime=  activeActivitiesObject.earliestArrivalTime.toString().substring(0,2)+"h"+activeActivitiesObject.earliestArrivalTime.toString().substring(2,4);
    String latestArrivalTime=  activeActivitiesObject.latestArrivalTime.toString().substring(0,2)+"h"+activeActivitiesObject.latestArrivalTime.toString().substring(2,4);
    String autreDetails = "Numéro civique "+activeActivitiesObject.location.civicNumber+
        ", suite : "+activeActivitiesObject.location.suite+
        ", immeuble : "+activeActivitiesObject.location.building+
        ", municipalité : "+activeActivitiesObject.location.municipalityName+
        ", térritoire : "+activeActivitiesObject.location.territory;


    return  FadedSlideAnimation(
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 10,),
          Expanded(
            //height: heightScreen*0.71,
            child:  SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 80,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            urlImage,
                            height: 52,
                            width: 42,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeActivitiesObject.tripInfo.firstName,
                              style: theme.textTheme.headline6,
                            ),
                            Spacer(flex: 1),
                            Text(
                              activeActivitiesObject.tripInfo.lastName,
                              style: theme.textTheme.subtitle2,
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PageRoutes.reviewsPage);
                          },
                          child: Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.shade500,
                            ),
                            child: Row(
                              children: [
                                Text(heureDepart, style: TextStyle(color: Colors.white, fontSize: 17),),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.timer_outlined,
                                  color: Colors.white,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 100,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Badge(
                              toAnimate: false,
                              elevation: 1,
                              badgeColor: activeActivitiesObject.activityType==3 ? Colors.green.shade400: Colors.red.shade400,
                              shape: BadgeShape.square,
                              borderRadius: BorderRadius.circular(2),
                              position: BadgePosition.topEnd(top: 0, end: -55),
                              padding: EdgeInsets.all(4),
                              badgeContent: Text(
                                type+" : $earliestArrivalTime - $latestArrivalTime",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),

                            ),
                            Spacer(flex: 2),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.accessibility_rounded,size: 15, color: Colors.grey,)),
                                  TextSpan(text: '- 01 passager(s)',style: TextStyle(fontSize: 12, color:Colors.grey.shade700 )),
                                ],
                              ),
                            ),
                            Spacer(flex: 2),
                            Text.rich(
                              TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.monetization_on_outlined,size: 15, color: Colors.grey,)),
                                  TextSpan(text: ' - LP',style: TextStyle(fontSize: 12, color:Colors.grey.shade700 )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadius.circular(16)),
                    child:SingleChildScrollView(
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Détails sur le transport",
                            style: theme.textTheme.bodyText1!.copyWith( fontSize: 14),
                          )),
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
                                textWithIcon("Adresse : ",
                                    activeActivitiesObject.location.streetTypeName +" "+ activeActivitiesObject.location.streetName+" ("+ activeActivitiesObject.location.streetTypeCode+")",
                                    15),
                                SizedBox(height: 5,),
                                textWithIcon("Intersection, ",activeActivitiesObject.location.intersection, 15),
                                SizedBox(height: 5,),
                                textWithIcon("Code postal : ",activeActivitiesObject.location.postalCode, 15),

                              ],
                            ),

                          ),
                          SizedBox(height: 15,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Autres détails",
                                style: theme.textTheme.bodyText1!.copyWith( fontSize: 14),
                              )),
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
                                Constante.textWithIcon("Numéro civique : ",activeActivitiesObject.location.civicNumber, 15),
                                SizedBox(height: 5,),
                                Constante.textWithIcon("Suite : ",activeActivitiesObject.location.suite, 15),
                                SizedBox(height: 5,),
                                Constante.textWithIcon("Immeuble : ",activeActivitiesObject.location.building, 15),
                                SizedBox(height: 5,),
                                Constante.textWithIcon("Municipalité : ",activeActivitiesObject.location.municipalityName, 15),
                                SizedBox(height: 5,),
                                Constante.textWithIcon("Térritoire : ",activeActivitiesObject.location.territory, 15),

                              ],
                            ),

                          ),
                          SizedBox(height: 20),

                        ],
                      ),
                    ),

                  ),

                ],
              ) ,
            ),
          ),
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }


  Widget buildCard(Widget widgetIcon, String titre, [Function? onTap]) {
    return  Expanded(
      child: GestureDetector(
        onTap: onTap as void Function()? ?? () {
         onTap;
        },
        child: Card(
          child:Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            padding: EdgeInsets.only(top: 10),
            height: 80,
            // child:Icon(icon, size: 40, color: colors,)
            child:Column(
              children: [
               widgetIcon,
                SizedBox(height: 2,),
                Center(
                  child:  Text(titre, style: TextStyle(color: Colors.grey.shade600, fontSize: 13),  textAlign: TextAlign.center,),
                )
              ],
            ),
            //child:Image.asset(urlImage,width:20 , height: 10,),
          ),
          elevation: 10,
        ),
      ),

      // Your column
    );
  }

  Widget setIcon( IconData icon, Color colors) {
    return Icon(icon, size: 25, color: colors);
  }

  Widget setImage( String urlImage , double hauteur, double largeur) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        urlImage,
        height: hauteur,
        width: largeur,
      ),
    );
  }

  Widget textWithIcon(String title, String value, double taille) {
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

  Widget embarquementCardBuild() {
    return     buildCard( currentEtape.action==1 ?
    setImage("assets/client_in.jpeg", 30, 30) :
    setIcon(Icons.electric_car_rounded, Colors.green.shade400),
        currentEtape.action==1 ? "Embarquement \n éffectué" : "Arrivé  \n  embarquement",
            (){
              if(currentEtape.action==0){
                Constante.alertPopup(context, "Confirmez-vous l'arrivé pour l'embarquement du client ?", () async {
                  Navigator.pop(context);
                  EasyLoading.show(status: 'Veuillez patienter...');
                  try{
                    var date = Constante.getDateForAPI(DateTime.now());
                    var hour= DateTime.now().hour;
                    var minute= DateTime.now().minute;
                    await runActivityEvent(widget.runkey.runIdentifier, widget.runkey.scheduleIdentifier, activeActivitiesObject.activityNo,
                        {
                      "arrivalTime": "$hour$minute",
                      "confirmArrival": true,
                      "date": "$date"
                        }
                    ).then((value){
                      EasyLoading.dismiss();
                      if(value.statusCode == 200){
                        setState(() {
                          currentEtape.action=1;
                        });
                      }else{
                        // print(value.body.toString());
                        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivitiesStepper(widget.listActivities.toList(), widget.idTourne)));
                        Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
                          duration: Toast.lengthLong,
                          gravity: Toast.bottom,
                          backgroundColor: Colors.red.shade400,
                          textStyle:TextStyle(color: Colors.white),
                        );
                      }
                    });
                  }
                  catch (e) {
                    print("erreur : "+e.toString());
                    EasyLoading.dismiss();
                    Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
                      duration: Toast.lengthLong,
                      gravity: Toast.bottom,
                      backgroundColor: Colors.black,
                      textStyle:TextStyle(color: Colors.white),
                    );
                  }
                });
              }
              if(currentEtape.action==1){
                showBarModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  expand: false,
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (context) => SingleChildScrollView(
                    controller: ModalScrollController.of(context),
                    child: modalPaymentBody(),
                  ),
                );
              }
        }
    );
  }

  Widget debarquementCardBuild() {
    return     buildCard( currentEtape.action==1 ?
    setImage("assets/client_out.jpeg", 30, 30) :
    setIcon(Icons.directions_car, Colors.red.shade400),
        currentEtape.action==1 ? "Débarquement \n éffectué" : "Arrivé  \n  débarquement",
            (){
      if(currentEtape.action==0){
        Constante.alertPopup(context, "Confirmez-vous l'arrivé pour le débarquement du client ?", () async {
          Navigator.pop(context);
          EasyLoading.show(status: 'Veuillez patienter...');
          try{
            var date = Constante.getDateForAPI(DateTime.now());
            var hour= DateTime.now().hour;
            var minute= DateTime.now().minute;
            await runActivityEvent(widget.runkey.runIdentifier, widget.runkey.scheduleIdentifier, activeActivitiesObject.activityNo,
                {
                  "arrivalTime": "$hour$minute",
                  "date": "$date"
                }
            ).then((value){
              EasyLoading.dismiss();
              if(value.statusCode == 200){
                setState(() {
                  currentEtape.action=1;
                });
              }else{
                // print(value.body.toString());
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivitiesStepper(widget.listActivities.toList(), widget.idTourne)));
                Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
                  duration: Toast.lengthLong,
                  gravity: Toast.bottom,
                  backgroundColor: Colors.red.shade400,
                  textStyle:TextStyle(color: Colors.white),
                );
              }
            });
          }
          catch (e) {
            print("erreur : "+e.toString());
            EasyLoading.dismiss();
            Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.black,
              textStyle:TextStyle(color: Colors.white),
            );
          }
        });

      }else if(currentEtape.action==1){
        Constante.alertPopup(context, "Confirmez-vous le débarquement du client ?", () async {
          Navigator.pop(context);
          EasyLoading.show(status: 'Veuillez patienter...');
          try{
            var date = Constante.getDateForAPI(DateTime.now());
            var hour= DateTime.now().hour;
            var minute= DateTime.now().minute;
            await runActivityEvent(widget.runkey.runIdentifier, widget.runkey.scheduleIdentifier, activeActivitiesObject.activityNo,      {
              "departureTime": "$hour$minute",
              "date": "$date"
            }).then((value){
              EasyLoading.dismiss();
              print(value.statusCode.toString());
              print(value.toString());
              if(value.statusCode == 200){
                if(activeStep == (widget.listActivities.length-1)){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BilanRidesPage(listClient, widget.idTourne, widget.runkey)));

                }else{
                  setState(() {
                    activeStep++;
                    activeActivitiesObject= widget.listActivities[activeStep];
                    currentEtape=listEtape[activeStep];
                  });
                }
              }else{
                // print(value.body.toString());
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivitiesStepper(widget.listActivities.toList(), widget.idTourne)));
                Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
                  duration: Toast.lengthLong,
                  gravity: Toast.bottom,
                  backgroundColor: Colors.red.shade400,
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

      }
    }

    );

  }
  /// Returns the next button.
  Widget nextButton() {
    return  InkWell(
      onTap: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < dotCount) {
          setState(() {
            activeStep++;
            activeActivitiesObject= widget.listActivities[activeStep];
          });
        }
      },
      child:Container(
        decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        margin: EdgeInsets.only(right: 2),
        height: 30,
        width:45,
        child:Icon(Icons.arrow_forward_ios, size: 25, color: Colors.white,),

      ),
    );

  }

  /// Returns the previous button.
  Widget previousButton() {
     return  InkWell(
      onTap: () {
        if (activeStep > 0) {
          setState(() {
            activeStep--;
            activeActivitiesObject= widget.listActivities[activeStep];
          });
        }
      },
      child:Container(
        decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        margin: EdgeInsets.only(left: 2),
        height: 30,
        width:45,
        child: Icon(Icons.arrow_back_ios, size: 25, color: Colors.white,),
      )
    );
  }

  Widget modalPaymentBody() {
    double heightScreen= MediaQuery.of(context).size.height;
    var listPaymentMode = activeActivitiesObject.tripInfo.passengers[0].paymentModes;
    final List<String> listMode = [];
    if (listPaymentMode != null) {
      listPaymentMode.forEach((element) {
        listMode.add(element);
      });
    }

    return  Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
      ),
      height: (heightScreen)-100,
      padding: EdgeInsets.all(10),
      child: Column(
        children:<Widget>[
          SizedBox(height: 10,),
          Center(
            child: Text("Sélectionner le mode de paiement"  ,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(height: 15,),
          Expanded(
              child: ListView(
                children: listMode.map((item){
                  return  buildFlatButtonPaymentMode( item,);
                }).toList(),
              ),
          ),
        ],
      )
    );
  }

  Widget buildFlatButtonPaymentMode( String paymentValue) {
    double widthScreen= MediaQuery.of(context).size.width;
    return Padding(padding: EdgeInsets.symmetric(vertical: 3),
      child: GestureDetector(
        onTap: (){
          Constante.alertPopup(context, "Confirmez-vous le \n mode \" $paymentValue \" \n pour le paiement ?", () async {
            Navigator.pop(context);
            Navigator.pop(context);
            EasyLoading.show(status: 'Veuillez patienter...');
            try{
              var date = Constante.getDateForAPI(DateTime.now());
              var hour= DateTime.now().hour;
              var minute= DateTime.now().minute;
              var cardNumber= activeActivitiesObject.tripInfo.passengers[0].cardNumber;
              await runActivityEvent(widget.runkey.runIdentifier, widget.runkey.scheduleIdentifier, activeActivitiesObject.activityNo,
                  {
                "departureTime": "$hour$minute",
                "date": "$date",
                "passengers": [
                  {
                    "passengerType": activeActivitiesObject.tripInfo.passengers[0].passengerType,
                    "paymentMode": "$paymentValue",
                    "cardNumber": "$cardNumber"
                  }
                ],
               }
              ).then((value){
                EasyLoading.dismiss();
                print(value.statusCode.toString());
                print(value.toString());
                if(value.statusCode == 200){
                  setState(() {
                    // get debarquement adress
                    // Activities act= widget.listActivities.firstWhere((p) => p.tripInfo.tripIdentifier == activeActivitiesObject.tripInfo.tripIdentifier  && p.activityType==4);
                    if(listClient.length>0){
                      Customer? customer= listClient.firstWhereOrNull((p) => p.idActivities == activeActivitiesObject.activityNo);
                      if(customer!=null){
                        var index= listClient.indexWhere((p) => p.idActivities == activeActivitiesObject.activityNo);
                        customer.paymentMode= paymentValue;
                        listClient[index]= customer;
                      }else{
                        var act= widget.listActivities.firstWhere((p) => p.tripInfo.tripIdentifier == activeActivitiesObject.tripInfo.tripIdentifier && p.activityType ==4);
                        listClient.add(new Customer(
                          idActivities: activeActivitiesObject.activityNo,
                          nom: activeActivitiesObject.tripInfo.firstName,
                          prenom: activeActivitiesObject.tripInfo.lastName,
                          paymentMode: paymentValue,
                          depart: activeActivitiesObject.location.streetTypeName +" "+ activeActivitiesObject.location.streetName+" ("+ activeActivitiesObject.location.streetTypeCode+")",
                          arrive: act.location.streetTypeName +" "+ act.location.streetName+" ("+ act.location.streetTypeCode+")",

                        ));
                      }
                    }
                    else{
                      var act= widget.listActivities.firstWhere((p) => p.tripInfo.tripIdentifier == activeActivitiesObject.tripInfo.tripIdentifier && p.activityType ==4);

                      listClient.add(new Customer(
                        idActivities: activeActivitiesObject.activityNo,
                        nom: activeActivitiesObject.tripInfo.firstName,
                        prenom: activeActivitiesObject.tripInfo.lastName,
                        paymentMode: paymentValue,
                        depart: activeActivitiesObject.location.streetTypeName +" "+ activeActivitiesObject.location.streetName+" ("+ activeActivitiesObject.location.streetTypeCode+")",
                        arrive: act.location.streetTypeName +" "+ act.location.streetName+" ("+ act.location.streetTypeCode+")",
                      ));
                    }

                    activeStep++;
                    activeActivitiesObject= widget.listActivities[activeStep];
                    currentEtape=listEtape[activeStep];

                  });
                }else{
                  // print(value.body.toString());
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivitiesStepper(widget.listActivities.toList(), widget.idTourne)));
                  Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
                    duration: Toast.lengthLong,
                    gravity: Toast.bottom,
                    backgroundColor: Colors.red.shade400,
                    textStyle:TextStyle(color: Colors.white),
                  );
                }
              });
            }
            catch (e) {
              print("erreur : "+e.toString());
              EasyLoading.dismiss();
              Toast?.show("Erreur de connexion au serveur veuillez réessayer.",
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.black,
                textStyle:TextStyle(color: Colors.white),
              );
            }

          });
        },
        child:  Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 2,
            child:  Container(
              padding: EdgeInsets.symmetric(),
              width: widthScreen,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              height:55,
              child: ListTile(
                  leading: Icon(
                    Icons.monetization_on_sharp,
                    color: Colors.grey,
                    size: 25,
                  ),
                  title: Text(paymentValue, textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 17, fontWeight: FontWeight.bold),
                  )

              ),
            )
        ),
      ),

    );


  }


  Widget modalBodyEvenement() {
    double heightScreen= MediaQuery.of(context).size.height;
    return Container(
      height:  heightScreen,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child:  Column(
          children: [
            Center(
              child: Text("Sélectionner l'évènement",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height:30,),
            _customDropDownExample(context, Icons.map, "Lieu problématique", "LIEUPROD"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,  Icons.timer_outlined,"Temps service d'embarquement / débarquement", "HORTEDIN"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,  Icons.drive_eta,"Problème circulation", "HORPROCI"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.accessibility_rounded,"Client pas prêt", "CLIPASPR"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.message,"Message général pour la tournée", "CM_TOU"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.warning_rounded,"Chauffeur signale une absence client et attend votre autorisation avant de procéder","BLANC",
                  () {
                    Constante.alertPopup(context, "Etes-vous sûr de vouloir signaler l'absence client ?", () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      EasyLoading.show(status: 'Veuillez patienter...');
                      try{
                        await runActivityComment(widget.runkey.runIdentifier, widget.runkey.scheduleIdentifier, activeActivitiesObject.activityNo, "BLANC", "Chauffeur signale une absence client et attend votre autorisation avant de procéder").then((value){
                          EasyLoading.dismiss();
                          print(value.statusCode.toString());
                          print(value.toString());
                          if(value.statusCode == 200){
                            Alert(
                              closeIcon: SizedBox(),
                              context: context,
                              type: AlertType.success,
                              title: "Veuillez patientez pendant que nous tentons de rejoindre le client.",
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
                          }else{
                              Toast?.show("Echèc de l'envoie du message",
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

              },
            ),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.location_off_sharp,"Chauffeur annule l'absence et procède à l'embarquement", "ANN_CLIABS"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.edit_location,"Personne ressource absente à l'adrese de destination","CM_TOU"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.messenger_outline,"Autres","CM_ACT"),
            Divider( color: Colors.transparent,),
          ],
        ),
      ),
    );



  }


  Widget _customDropDownExample( BuildContext context, IconData iconData, String? titre,String? code, [Function? onTap]) {
    return GestureDetector(
        onTap: onTap as void Function()? ?? () {
    Constante.alertPopup(context, "Etes-vous sûr de vouloir cette  demande ?", () async {
      Navigator.pop(context);
      Navigator.pop(context);
      EasyLoading.show(status: 'Veuillez patienter...');
      try{
        await runActivityComment(widget.runkey.runIdentifier, widget.runkey.scheduleIdentifier, activeActivitiesObject.activityNo, code, titre).then((value){
          EasyLoading.dismiss();
          print(value.statusCode.toString());
          print(value.toString());
          if(value.statusCode == 200){
            Toast?.show("Message envoyé avec succès.",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.green.shade400,
              textStyle:TextStyle(color: Colors.white),
            );
          }else{
            // print(value.body.toString());
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivitiesStepper(widget.listActivities.toList(), widget.idTourne)));
            Toast?.show("Echèc de l'envoie du message",
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
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color:Colors.grey.shade300
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(iconData, color: Colors.blue.shade700,size: 20,),
            ),
            title: Text(titre!),
          ),
        )
    );


  }





}

