import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qcabs_driver/DrawerPages/Home/offline_page.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Assets/assets.dart';
import '../../Components/custom_button.dart';
import '../../Components/entry_field.dart';
import '../../Constante.dart';
import '../../Locale/strings_enum.dart';
import 'package:http/http.dart' as http;

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  TextEditingController numeroVehiculeField =
      TextEditingController(text: Constante.numeroVehicule);
  var numvehicule ="";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String token ="";

  @override
  void dispose() {
    numeroVehiculeField.dispose();
    super.dispose();
  }

  void saveNumeroVehicule() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constante.key_numero_vehicule, numvehicule);
    Constante.numeroVehicule= numvehicule;
  }

  Future closeSession() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(Constante.key_token)!;
    var urlApi= Constante.serveurAdress+"vehicule/closeVehicleSession";
    var vehicleIdentifier= Constante.numeroVehicule;
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
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      saveNumeroVehicule();
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
    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            getString(Strings.MY_PROFILE)!,
                            style: theme.textTheme.headline5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Text(
                            getString(Strings.YOUR_ACCOUNT_DETAILS)!,
                            style: theme.textTheme.bodyText2!
                                .copyWith(color: theme.hintColor),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 72),
                          height: 72,
                          color: theme.backgroundColor,
                        ),
                      ],
                    ),
                    PositionedDirectional(
                      start: 24,
                      top: 100,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: AssetImage(Assets.Driver))),
                        alignment: Alignment.center,
                      ),
                    ),
                    PositionedDirectional(
                      start: 140,
                      top: 108,
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.drive_eta,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Véhicule "+ Constante.numeroVehicule,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: Theme.of(context).hintColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: theme.backgroundColor,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        Form(
                          key: formKey,
                          child:  Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              TextFormField(
                                controller: numeroVehiculeField,
                                minLines: 1, // <-- SEE HERE
                                maxLines: 1,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Changer le numéro de votre véhicule ici',
                                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black26)
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black26)
                                  ),
                                ),
                                validator: (String ? value){
                                  if(value!.isEmpty){
                                    return "Ce champ est obligatoire";
                                  }
                                  if(value.toString().length>4){
                                    return "Ce numéro n'est pas valide";
                                  }
                                  numvehicule = value;
                                  return null;
                                },
                              ),

                            ],
                          ),
                        ),






                      ],
                    ),
                  ),
                ),
                CustomButton(
                  text: "Sauvegarder",
                   onTap: (){
                     if(formKey.currentState!.validate()){
                       print("numero vehicule : "+ numvehicule);
                       print("local num : "+ Constante.numeroVehicule);
                       Constante.alertPopup(context, "En acceptant la sauvegarde vous serez deconnectez de l'application ?",
                           (){
                             EasyLoading.show( status: "Deconnexion en cours...", dismissOnTap: false);
                             closeSession();

                           });
                     }
                   }
                  //     .register(_nameController.text, _emailController.text),
                ),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
