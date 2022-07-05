import 'dart:ffi';

import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:badges/badges.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcabs_driver/Assets/assets.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Components/row_item.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:qcabs_driver/Theme/style.dart';
import 'package:qcabs_driver/model/Routes.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StepperPage extends StatefulWidget {
  late Routes routes;

  StepperPage( Routes routes){
    this.routes=routes;
  }

  @override
  _StepperPage createState() => _StepperPage();
}

class _StepperPage extends State<StepperPage> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 5.

  int upperBound = 7;

  bool isOpened = true;
  bool rideAccepted = false;// upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width= MediaQuery.of(context).size.width;
    double heightScreen= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title:
        Text((activeStep!=0 ? buttonText(activeStep-1):"En attente..."),
          style: Theme.of(context).textTheme.headline6,
        ) ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ImageStepper(
              activeStepBorderColor: Colors.green.shade500,
              activeStepColor: Colors.red.shade300,
              activeStepBorderPadding:1 ,
              activeStepBorderWidth:6 ,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              images: [
                AssetImage("assets/load.jpeg"),
                AssetImage("assets/checked.jpeg"),
                AssetImage("assets/begin.jpeg"),
                AssetImage("assets/arrived_client.jpeg"),
                AssetImage("assets/client_in.jpeg"),
                AssetImage("assets/destination.jpeg"),
                AssetImage("assets/client_out.jpeg"),
                AssetImage("assets/pret_go.png"),
              ],
              // activeStep property set to activeStep variable defined above.
              activeStep: activeStep,

              // This ensures step-tapping updates the activeStep.
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            new Expanded (
              child:  FadedSlideAnimation(
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: heightScreen*0.61,
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
                                      Assets.Client,
                                      height: 72,
                                      width: 72,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sam Smith',
                                        style: theme.textTheme.headline6,
                                      ),
                                      Spacer(flex: 2),
                                      Text(
                                        '12 janvier 2022, 10:25 ',
                                        style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
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
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.red.shade500,
                                      ),
                                      child: Row(
                                        children: [
                                          Text("A venir", style: TextStyle(color: Colors.white, fontSize: 12),),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.timer_outlined,
                                            color: Colors.white,
                                            size: 12,
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
                              decoration: BoxDecoration(
                                  color: theme.backgroundColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child:SingleChildScrollView(
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "Détails sur le transport",
                                        style: theme.textTheme.headline6!
                                            .copyWith(color: theme.hintColor, fontSize: 14),
                                      ),
                                      trailing: Text('Horaires',
                                        style: theme.textTheme.headline6!
                                            .copyWith(color: theme.hintColor, fontSize: 14),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.location_on,
                                        color: theme.primaryColor,
                                      ),
                                      title: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Départ : ",
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)
                                            ),
                                            TextSpan(
                                                text: " Roméo-Vachon Nord",
                                                style: TextStyle(fontSize: 15, color: Colors.black,)

                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing: Badge(
                                        toAnimate: false,
                                        elevation: 0,
                                        shape: BadgeShape.square,
                                        badgeColor: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(3),
                                        position: BadgePosition.topEnd(top: 0, end: 0),
                                        padding: EdgeInsets.all(4),
                                        badgeContent: Text(
                                          " 12:30",
                                          style: TextStyle(
                                              color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.navigation,
                                        color: theme.primaryColor,
                                      ),
                                      title:RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Arrivée : ",
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)
                                            ),
                                            TextSpan(
                                                text: "800, place Leigh-Capreol",
                                                style: TextStyle(fontSize: 15, color: Colors.black,)

                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing: Badge(
                                        toAnimate: false,
                                        elevation: 0,
                                        shape: BadgeShape.square,
                                        badgeColor: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(3),
                                        position: BadgePosition.topEnd(top: 0, end: 0),
                                        padding: EdgeInsets.all(4),
                                        badgeContent: Text(
                                          " 12:30",
                                          style: TextStyle(
                                              color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                      child:  ExpandablePanel(
                                        header: Text(
                                            "Autres détails ",
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                        collapsed: Text("Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée. Généralement, on utilise un texte en faux latin, le Lorem ipsum ou Lipsum.",
                                          softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,
                                          style:Theme.of(context).textTheme.bodyText1,),
                                        expanded: Text("Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée. Généralement, on utilise un texte en faux latin, le Lorem ipsum ou Lipsum.",
                                          softWrap: true, style: Theme.of(context).textTheme.bodyText1, ),

                                      ),
                                    ),
                                    SizedBox(height: 20),

                                  ],
                                ),
                              ),

                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                // color: Theme.of(context).backgroundColor,
                                padding: EdgeInsets.only(
                                    left: 8, top: 10, right: 8, bottom: 10),
                                child: Row(
                                  children: [
                                    buildFlatButton(
                                        Icons.message,"Signaler un évènement",
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                // color: Theme.of(context).backgroundColor,
                                padding: EdgeInsets.only(
                                    left: 8, top: 0, right: 8, bottom: 10),
                                child: Row(
                                  children: [
                                    buildFlatButton(
                                      Icons.call,"Appeler centrale",
                                          () {
                                      },
                                    ),
                                    SizedBox(width: 5,),
                                    buildFlatButton(
                                      Icons.call,"Appeler client",
                                          () {
                                      },
                                    ),
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
              ),
            ),
            Container(
              width: width,
              child: CustomButton(
                icon: Icons.double_arrow,
                onTap: () {

                  buttonAction();
                },
                text: buttonText(activeStep),
              ),
            )






          ],
        ),

      ),
    );
  }





  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              buttonText(activeStep),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String buttonText( int activeValue) {
    switch (activeValue) {
      case 1:
        return 'Débuter le transport';

      case 2:
        return 'Arrivée chez le client';

      case 3:
        return 'Confirmer l\'embarquement ';

      case 4:
        return 'Arrivée à destination';

      case 5:
        return 'Débarquement du client';

      case 6:
        return 'Prêt pour un autre voyage';

      case 7:
        return 'Terminer';

      default:
        return 'Confirmer le transport';
    }
  }

  void nextStep() {
    setState(() {
      activeStep++;
    });
  }


  void buttonAction() {
    if (activeStep <= upperBound) {
      print("nombre"+ activeStep.toString());
      if(activeStep==1){
        showBarModalBottomSheet(
          backgroundColor: Colors.transparent,
          expand: false,
          context: context,
          isDismissible: false,
          enableDrag: false,
          builder: (context) => SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: modalBody(),
          ),
        );
      }
      else if(activeStep==7){
        Navigator.pop(context);
      }else{
      nextStep();
      }
    }
  }


  Widget buildFlatButton(IconData icon, String text, [Function? onTap]) {
    return Expanded(
      child: TextButton.icon(
        style: TextButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.green.shade200,
          padding: EdgeInsets.symmetric(vertical: 12)
        ),
        onPressed: onTap as void Function()? ?? () {},
        icon: Icon(
          icon,
          size: 22,
          color: Theme.of(context).primaryColor,
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 16),
        ),
      ),
    );
  }


  Widget modalBody() {
    double heightScreen= MediaQuery.of(context).size.height;
    return  Container(
      height: (heightScreen/3)+100,
      padding: EdgeInsets.all(10),
      child:SingleChildScrollView(
        child:Column(
          children: [
            Center(
              child: Text("Sélectionner le mode de paiement"  ,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 20,),
            buildFlatButtonPaymentMode( Icons.payment_outlined, "Paiement par carte ",
            ),
            SizedBox(height: 10,),
            buildFlatButtonPaymentMode( Icons.monetization_on_outlined, "Paiement en espèce ",),
            SizedBox(height: 10,),
            buildFlatButtonPaymentMode( Icons.money_sharp, "Paiement carte membre ",),
            SizedBox(height: 10,),
            buildFlatButtonPaymentMode( Icons.money_off, "Aucun paiement",),
          ],
        ),
      ),

    );
  }

  Widget buildFlatButtonPaymentMode(IconData icon, String text, [Function? onTap]) {
    double widthScreen= MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: widthScreen,
      height:50,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          backgroundColor: Colors.green.shade200,
        ),
        onPressed: onTap as void Function()? ?? () {
          Navigator.pop(context);
          nextStep();

        },
        icon: Icon(
          icon,
          size: 22,
          color: Theme.of(context).primaryColor,
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 17),
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
            _customDropDownExample(context, Icons.map, "Lieu problématique"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,  Icons.timer_outlined,"Temps service d'embarquement / débarquement"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,  Icons.drive_eta,"Problème circulation"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.accessibility_rounded,"Client pas prêt"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.message,"Message général pour la tournée"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.warning_rounded,"Chauffeur signale une absence client et attend votre autorisation avant de procéder",
                  () {
                Alert(
                  closeIcon: SizedBox(),
                  context: context,
                  type: AlertType.info,
                  title: "Etes-vous sûr de vouloir signaler une demande d'absence ?",
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
                      onPressed: (){
                        Navigator.pop(context);

                        Alert(
                          closeIcon: SizedBox(),
                          context: context,
                          type: AlertType.success,
                          title: "Veuillez patientez pendant que nous tentons de rejoindre le client ?",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Fermer",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              gradient: LinearGradient(colors: [
                                Colors.red.shade500,
                                Colors.red.shade600
                              ]),
                            )
                          ],
                        ).show();

                      },
                      gradient: LinearGradient(colors: [
                        Colors.green.shade500,
                        Colors.green.shade600
                      ]),
                    )
                  ],
                ).show();
              },
            ),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.location_off_sharp,"Chauffeur annule l'absence et procède à l'embarquement"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.edit_location,"Personne ressource absente à ladrese de destination"),
            Divider( color: Colors.transparent,),
            _customDropDownExample(context,Icons.messenger_outline,"Autres"),
            Divider( color: Colors.transparent,),
          ],
        ),
      ),
    );



  }


  Widget _customDropDownExample( BuildContext context, IconData iconData, String? item, [Function? onTap]) {
    return GestureDetector(
      onTap: onTap as void Function()? ?? () {
        Alert(
          closeIcon: SizedBox(),
          context: context,
          type: AlertType.info,
          title: "Etes-vous sûr de vouloir signaler une demande ?",
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
              onPressed: (){
                Navigator.pop(context);

                Alert(
                  closeIcon: SizedBox(),
                  context: context,
                  type: AlertType.success,
                  title: "Evènement signalé avec succès ?",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Fermer",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.pop(context);

                      },
                      gradient: LinearGradient(colors: [
                        Colors.red.shade500,
                        Colors.red.shade600
                      ]),
                    )
                  ],
                ).show();

              },
              gradient: LinearGradient(colors: [
                Colors.green.shade500,
                Colors.green.shade600
              ]),
            )
          ],
        ).show();
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
          title: Text(item!),
        ),
      )
    );


  }

}

