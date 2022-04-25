import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import '../../Assets/assets.dart';

class MyRidesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, PageRoutes.stepperPage),
                   // Navigator.pushNamed(context, PageRoutes.rideInfoPage),
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
                            child: Image.asset(Assets.Client),
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Boudreau lambert',
                                style: theme.textTheme.bodyText2,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '12/03/2022 à 12:15',
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
                                badgeColor: Colors.red.shade500,
                                shape: BadgeShape.square,
                                borderRadius: BorderRadius.circular(5),
                                position: BadgePosition.topEnd(top: 0, end: -55),
                                padding: EdgeInsets.all(3),
                                badgeContent: Text(
                                  "A venir",
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
                        color: theme.primaryColor,
                        size: 20,
                      ),
                      title: Text('Départ : 975, boulevard Roméo-Vachon Nord'),
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
                        size: 20,
                      ),
                      title: Text('Arrivé : 800, place Leigh-Capreol'),
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
                          " 18:40",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),



                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
