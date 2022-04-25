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
import 'package:rflutter_alert/rflutter_alert.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPage createState() => _DetailsPage();
}

class _DetailsPage extends State<DetailsPage> {
// upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width= MediaQuery.of(context).size.width;
    double heightScreen= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Détails",
                style: theme.textTheme.headline5,
              ),
            ),
            SizedBox(height: 20),
            new Expanded (
              child:  FadedSlideAnimation(
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child:  SingleChildScrollView(
                        child: Column(
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
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green.shade500,
                                      ),
                                      child: Row(
                                        children: [
                                          Text("Complété", style: TextStyle(color: Colors.white, fontSize: 12),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              height: heightScreen*0.65,
                              decoration: BoxDecoration(
                                  color: theme.backgroundColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child:  Column(
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
                                  SizedBox(height: 20,),
                                  Expanded(
                                      child: SingleChildScrollView(  // <-- wrap this around
                                        child: Column(
                                          children: <Widget>[
                                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                              child:  ExpandablePanel(
                                                header: Text(
                                                  "Autres détails ",
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                                collapsed: Text("Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée. Généralement, on utilise un texte en faux latin, le Lorem ipsum ou Lipsum.",
                                                  softWrap: true, maxLines: 40, overflow: TextOverflow.ellipsis,
                                                  style:Theme.of(context).textTheme.bodyText1,),
                                                expanded: Text("Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée. Généralement, on utilise un texte en faux latin, le Lorem ipsum ou Lipsum."
                                                    "Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée. Généralement, on utilise un texte en faux latin, le Lorem ipsum ou Lipsum."
                                                    "Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée. Généralement, on utilise un texte en faux latin, le Lorem ipsum ou Lipsum.",
                                                  softWrap: true, style: Theme.of(context).textTheme.bodyText1, ),

                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),

                                  SizedBox(height: 10,)
                                ],
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






          ],
        ),

      ),
    );
  }


  Widget modalBodyDetails() {
    double heightScreen= MediaQuery.of(context).size.height;
    return Container(
      height:  heightScreen/3,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child:  Column(
          children: [
            ListTile(
              title:Text("Détails sur le transport"  ,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_up_rounded, color: Colors.grey, size: 20,),

            ),
            SizedBox(height: 10,),
            Text("Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée. Généralement, on utilise un texte en faux latin, le Lorem ipsum ou Lipsum."  ,
              style: Theme.of(context).textTheme.bodyText1,

            ),
          ],
        ),
      ),
    );



  }


}

