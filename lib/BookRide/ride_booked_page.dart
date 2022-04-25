import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import '../Assets/assets.dart';
import '../Components/background_image.dart';
import '../Components/custom_button.dart';
import '../Theme/style.dart';
import 'package:qcabs_driver/Locale/locale.dart';

class RideBookedPage extends StatefulWidget {
  @override
  _RideBookedPageState createState() => _RideBookedPageState();
}

class _RideBookedPageState extends State<RideBookedPage> {
  bool isOpened = false;
  bool rideAccepted = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: FadedSlideAnimation(
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    SafeArea(
                      child: rideAccepted
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text(getString(Strings.GO_TO_PICKUP)!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              letterSpacing: 0.7,
                                              fontSize: 16)),
                                  Spacer(),
                                  Text(
                                    getString(Strings.NAVIGATE)!.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            letterSpacing: 0.7,
                                            fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.navigation_rounded,
                                    color: Theme.of(context).primaryColor,
                                  )
                                ],
                              ),
                            )
                          : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: "Reçus le " +
                                        '\n',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                            letterSpacing: 0.5)),
                                TextSpan(
                                    text: '10/12/2022 à 21:20',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5)),
                              ])),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: GestureDetector(
                        onVerticalDragDown: (details) {
                          setState(() {
                            isOpened = !isOpened;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: isOpened ? 110 : 150,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: isOpened
                                ? BorderRadius.circular(16)
                                : BorderRadius.vertical(
                                    top: Radius.circular(16)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  Assets.Client,
                                  height: 72,
                                  width: 72,
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                // mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Boudreau lambert',
                                    style: theme.textTheme.headline6,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    getString(Strings.PICKUP_DESTINATION)!,
                                    style: theme.textTheme.caption,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'boulevard Roméo-Vachon Nord',
                                    style: theme.textTheme.bodyText1,
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, PageRoutes.reviewsPage);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.blue.shade900,
                                  ),
                                  child: Row(
                                    children: [
                                      Text("12:30", style: TextStyle(color: Colors.white),),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.timer_outlined,
                                        color: Colors.white,
                                        size: 14,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Details(isOpened ? 270 : 0),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: 72,
                      color:
                          isOpened ? Colors.transparent : theme.backgroundColor,
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // color: Theme.of(context).backgroundColor,
                    padding: EdgeInsets.only(
                        left: 8, top: 12, right: 8, bottom: 70),
                    child: Row(
                      children: [

                        buildFlatButton(Icons.close, getString(Strings.CANCEL)!),
                        Spacer(),
                        buildFlatButton(
                            isOpened
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            isOpened
                                ? getString(Strings.LESS)!
                                : getString(Strings.MORE)!, () {
                          setState(() {
                            isOpened = !isOpened;
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                PositionedDirectional(
                  bottom: 0,
                  start: 0,
                  end: 0,
                  child: CustomButton(
                    onTap: () {
                      if (rideAccepted)
                        Navigator.pushNamed(context, PageRoutes.beginRide);
                      setState(() {
                        rideAccepted = true;
                      });
                    },
                    text: rideAccepted
                        ? getString(Strings.ARRIVED)
                        : getString(Strings.ACCEPT_RIDE),
                  ),
                )
              ],
            ),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ),
      ],
    );
  }

  Widget buildFlatButton(IconData icon, String text, [Function? onTap]) {
    return Expanded(
      flex: 10,
      child: TextButton.icon(
        onPressed: onTap as void Function()? ?? () {},
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        icon: Icon(
          icon,
          size: 18,
          color: Theme.of(context).primaryColor,
        ),
        label: Text(
          text,
          style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class Details extends StatefulWidget {
  final double height;

  Details(this.height);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: widget.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      getString(Strings.RIDE_INFO)!,
                      style: theme.textTheme.bodyText1!
                          .copyWith(color: theme.hintColor, fontSize: 18),
                    ),
                    trailing: Text('Horaires', style: theme.textTheme.bodyText1!
                        .copyWith(color: Colors.black, fontSize: 18), ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: theme.primaryColor,
                    ),
                    title: Text('boulevard Roméo-Vachon Nord'),
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
                    title: Text('800, place Leigh-Capreol'),
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
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  buildRowItem(theme, getString(Strings.PAYMENT_VIA)!,
                      getString(Strings.WALLET)!, Icons.account_balance_wallet),
                  Spacer(),
                  buildRowItem(theme, getString(Strings.RIDE_TYPE)!,
                      getString(Strings.GO_PRIVATE)!, Icons.drive_eta),
                ],
              ),
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

  Column buildRowItem(
      ThemeData theme, String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyText1!.copyWith(color: theme.hintColor),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: theme.primaryColor),
            SizedBox(width: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyText1!.copyWith(fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}
