import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Components/background_image.dart';
import 'package:qcabs_driver/Components/ripple_animation.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:qcabs_driver/Theme/colors.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import '../../Assets/assets.dart';
import '../../Locale/locale.dart';
import '../app_drawer.dart';

class MenuTile {
  String title;
  String subtitle;
  IconData iconData;
  Function onTap;

  MenuTile(this.title, this.subtitle, this.iconData, this.onTap);
}

class OfflinePage extends StatefulWidget {
  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  bool isOnline = false;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool isAccountOpen = false;

  @override
  void initState() {
    /*Future.delayed(Duration(seconds: 5), () {
      Navigator.pushNamed(context, PageRoutes.rideBookedPage);
    });*/
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: AppDrawer(),
      body: FadedSlideAnimation(
        SafeArea(
          child: Stack(
            children: [
              BackgroundImage(),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                          Theme
                              .of(context)
                              .scaffoldBackgroundColor == Colors.black
                              ? Colors.black12
                              : Colors.white12,
                        ])),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 70,
              ),
              Column(
                children: [
                  ListTile(
                    leading: GestureDetector(
                     onTap:() {
                       Navigator.pushNamed(context, PageRoutes.myProfilePage);
                     },
                       child:  ClipRRect(
                           borderRadius: BorderRadius.circular(8),
                           child: FadedScaleAnimation(Image.asset(Assets.Driver))),
                     ),

                    /*Image.asset('assets/delivery_boy.png'),*/
                    title: Text("Thomas Meunier"),
                    subtitle: GestureDetector(
                      onTap:() {
                        Navigator.pushNamed(context, PageRoutes.myRidesPage);
                      },
                      child:  Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Badge(
                              shape: BadgeShape.square,
                              borderRadius: BorderRadius.circular(5),
                              position: BadgePosition.topEnd(top: 0, end: -150),
                              padding: EdgeInsets.all(2),
                              badgeContent: Text(
                                " 10 transports à faire aujourd'hui",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              child: Icon(Icons.drive_eta, color: Colors.black, size: 18,),

                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, color: Colors.black, size: 17,),
                                SizedBox(width: 12),
                                Text(
                                  "13 janvier 2022",
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        ),

                      ),
                    ),

                    trailing:  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, PageRoutes.notificationPage);
                      },
                      child:  Badge(
                        badgeColor: Colors.green.shade500,
                        position: BadgePosition.topEnd(top: -17, end: -10),
                        badgeContent: Text('3', style: TextStyle(color: Colors.white),),
                        child: Icon(Icons.notifications, color: Colors.black,),
                      ),
                    ),

                  ),
                  Spacer(),
                  !isOnline
                      ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isOnline = !isOnline;
                      });
                      Navigator.pushNamed(context, PageRoutes.myRidesPage);
                    },
                    child: RipplesAnimation(
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  )
                      : SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
      bottomSheet: SolidBottomSheet(
          maxHeight: 80,
          draggableBody: true,
          canUserSwipe: true,
          toggleVisibilityOnTap: true,
          elevation: 5,
          headerBar: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _drawerKey.currentState!.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(
                        Icons.menu,
                        color: Theme
                            .of(context)
                            .primaryColor,
                      ),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 16,
                  ),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: isOnline ? onlineColor : offlineColor,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    isOnline
                        ? getString(Strings.YOU_RE_ONLINE)!.toUpperCase()
                        : getString(Strings.YOU_RE_OFFLINE)!.toUpperCase(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(
                        fontWeight: FontWeight.w500, letterSpacing: 0.5),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.keyboard_arrow_up,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
          body: Material(
              color: Theme
                  .of(context)
                  .scaffoldBackgroundColor,
              elevation: 5,
              child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      SizedBox(
                        width: 44,
                      ),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: !isOnline ? onlineColor : offlineColor,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isOnline = !isOnline;
                            });
                          },
                          child: Text(
                              !isOnline
                                  ? getString(Strings.YOU_RE_ONLINE)!
                                  .toUpperCase()
                                  : getString(Strings.YOU_RE_OFFLINE)!
                                  .toUpperCase(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5))),
                      SizedBox(
                        width: 45,
                      ),
                      Spacer(),
                    ],
                  ))
          )
      ),
    );
  }
}
