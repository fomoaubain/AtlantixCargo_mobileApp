import 'dart:convert';
import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qcabs_driver/Assets/assets.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:qcabs_driver/Theme/style.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Constante.dart';

class AppDrawer extends StatefulWidget {
  final bool fromHome;

  AppDrawer([this.fromHome = true]);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  late String token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSession();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    token= prefs.getString('token').toString();
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
     prefs.clear();
  }

  Future closeSession() async {
    var urlApi= Constante.serveurAdress+"vehicule/closeVehicleSession";
    var vehicleIdentifier=5;
    Map jsonBody = {'vehicleIdentifier': "$vehicleIdentifier" };
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

    print("statuscode : " + response.statusCode.toString());

    if (response.statusCode == 200) {
      clearSession();
      EasyLoading.dismiss();
      Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
    }else{
      EasyLoading.dismiss();
      EasyLoading.showInfo("Impossible de se connecter au serveur.", duration: Duration(seconds: 4), dismissOnTap: true);

    }

  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Builder(builder: (BuildContext context){

      return Drawer(
        child: SafeArea(
          child: FadedSlideAnimation(
            ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 20),
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                Assets.Driver,
                                height: 72,
                                width: 72,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Véhicule 6',
                                    style: theme.textTheme.headline6),
                                SizedBox(height: 6),
                                Text('+1 (866) 813-1234',
                                    style: theme.textTheme.caption),
                                SizedBox(height: 4),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.close),
                          color: theme.primaryColor,
                          iconSize: 28,
                          onPressed: () => Navigator.pop(context)),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                buildListTile(
                    context, Icons.home, context.getString(Strings.HOME)!, () {
                  if (widget.fromHome)
                    Navigator.pushReplacementNamed(
                        context, PageRoutes.offlinePage);
                  else
                    Navigator.pushReplacementNamed(
                        context, PageRoutes.offlinePage);
                }),
                buildListTile(context, Icons.person,
                    context.getString(Strings.MY_PROFILE)!, () {
                      Navigator.popAndPushNamed(context, PageRoutes.myProfilePage);
                    }),
                buildListTile(context, Icons.drive_eta,
                    context.getString(Strings.MY_RIDES)!, () {
                      Navigator.popAndPushNamed(context, PageRoutes.myRidesPage);
                    }),
                buildListTile(context, Icons.list,
                    "Historique des transports", () {
                      Navigator.popAndPushNamed(context, PageRoutes.historiquePage);
                    }),
              /*  buildListTile(
                    context, Icons.star, context.getString(Strings.MY_RATINGS)!,
                        () {
                      Navigator.popAndPushNamed(context, PageRoutes.reviewsPage);
                    }),*/
               /* buildListTile(context, Icons.account_balance_wallet,
                    context.getString(Strings.WALLET)!, () {
                      if (widget.fromHome)
                        Navigator.popAndPushNamed(context, PageRoutes.walletPage);
                      else
                        Navigator.pushReplacementNamed(
                            context, PageRoutes.walletPage);
                    }),
                buildListTile(context, Icons.local_offer,
                    context.getString(Strings.PROMO_CODE)!, () {
                      if (widget.fromHome)
                        Navigator.popAndPushNamed(context, PageRoutes.promoCode);
                      else
                        Navigator.pushReplacementNamed(
                            context, PageRoutes.promoCode);
                    }),*/
                buildListTile(context, Icons.settings,
                    context.getString(Strings.SETTINGS)!, () {
                      if (widget.fromHome)
                        Navigator.popAndPushNamed(context, PageRoutes.settingsPage);
                      else
                        Navigator.pushReplacementNamed(
                            context, PageRoutes.settingsPage);
                    }),
                buildListTile(
                    context, Icons.mail, context.getString(Strings.CONTACT_US)!,
                        () {
                      if (widget.fromHome)
                        Navigator.popAndPushNamed(
                            context, PageRoutes.contactUsPage);
                      else
                        Navigator.pushReplacementNamed(
                            context, PageRoutes.contactUsPage);
                    }),
                 buildListTile(
                    context, Icons.lock_open_rounded, "Se deconnecter", () {
                   EasyLoading.show( status: "Deconnexion en cours...", dismissOnTap: false);
                   closeSession();
                 }),
              ],
            ),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ),
      );
    });
  }

  ListTile buildListTile(BuildContext context, IconData icon, String title,
      [Function? onTap]) {
    var theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor, size: 24),
      title: Text(
        title,
        style: theme.textTheme.headline5!
            .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      onTap: onTap as void Function()?,
    );
  }
}
