
import 'dart:convert';
import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Components/entry_field.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../../Constante.dart';
import 'login_interactor.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LoginUI extends StatefulWidget {
  final LoginInteractor loginInteractor;

  LoginUI(this.loginInteractor);

  @override
  _LoginUIState createState() => _LoginUIState();
}


class _LoginUIState extends State<LoginUI> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _login =
  TextEditingController(text: '');
  final TextEditingController _password =
  TextEditingController(text: '');

  late bool showbutton= false;

  String isoCode = '';
  late Position? position=null;

   var numeroVehicule="" ;

  static final Config config = Config(
    tenant: Constante.tenant,
    clientId:  Constante.clientId,
    scope:  Constante.scope,
    redirectUri:  Constante.redirectUri,
    isB2C: true,
    policy: Constante.policy,
  );
  final AadOAuth oauth = AadOAuth(config);


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      verifiedParam();
    });
  //  Constante.gpsPermission();
  }


  Future openSession(String token) async {

   var urlApi= Constante.serveurAdress+"vehicule/openVehicleSession";
   String date =  Constante.getDateForAPI(DateTime.now());
    Map jsonBody = {'vehicleIdentifier': "$numeroVehicule",
                    'gpsPosition':{
                      "longitude": position!=null ?position!.longitude : 0,
                      "latitude":position!=null ? position!.latitude : 0,
                     // "date": "2022",
                      "time": position!=null ? DateFormat.Hm().format(position!.timestamp!) :"",
                      "speed": position!=null ? position!.speed :0
                    }
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
    print("statuscode : " + response.statusCode.toString());
    //print("response body : " + response.body.toString());
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      saveNumeroVehicule();
      Navigator.pushReplacementNamed(context, PageRoutes.offlinePage);
    }else{
      EasyLoading.dismiss();
      Toast?.show("Echèc de la connexion",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
        backgroundColor: Colors.black,
      textStyle:TextStyle(color: Colors.white),
      );

      setState(() {
        showbutton=true;
      });
    }
  }


  Future verifiedParam() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey(Constante.key_numero_vehicule)){
      showPopup();
    }else{
      getNumeroVehicule();
      setState(() {
        showbutton=true;
      });
    }
  }

   showPopup() {
    return  Alert(
      onWillPopActive: true,
      useRootNavigator: false,
      closeIcon: SizedBox(),
      context: context,
      type: AlertType.none,
      title: "Entrer le numéro de votre véhicule.",
      content:Form(
        key: formKey,
        child:  Column(
          children: <Widget>[
            SizedBox(height: 10,),
            TextFormField(
              minLines: 1, // <-- SEE HERE
              maxLines: 1,
              obscureText: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Saisir ici',
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                numeroVehicule = value;
                return null;
              },
            ),

          ],
        ),
      ),

      buttons: [
        DialogButton(
          child: Text(
            "Sauvegarder",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            if(formKey.currentState!.validate()){
              print("numero vehicule : "+ numeroVehicule);
              setState(() {
                showbutton= true;
              });
             Navigator.pop(context);
            }
          },
          gradient: LinearGradient(colors: [
            Colors.blue.shade800,
            Colors.blue.shade800
          ]),
        )
      ],
    ).show();
  }

  void saveNumeroVehicule() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constante.key_numero_vehicule, numeroVehicule);
    Constante.numeroVehicule= numeroVehicule;
  }

  void getNumeroVehicule() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     numeroVehicule = (await prefs.getString(Constante.key_numero_vehicule))!;
     Constante.numeroVehicule= numeroVehicule;
  }





  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // adjust window size for browser login
    ToastContext().init(context);
    var theme = Theme.of(context);
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(flex: 3),
                Container(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: (width/6)),
                      child:Center(
                        child:Image.asset('assets/app_splash.png', height: 70.0,),
                      )
                  ),
                ),
                Spacer(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  color: theme.backgroundColor,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget> [


                         showbutton ?  RawMaterialButton(
                      elevation: 4,
                    fillColor: Colors.white,
                      splashColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:  <Widget>[
                            Center(
                              child:Image.asset('assets/azure.png', height: 50.0, width: 40, ),
                            ),

                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Se connecter",
                              maxLines: 1,
                              style: TextStyle(color: theme.primaryColor, fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                      login();
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),

                      ),
                    ) : SizedBox(),
                        showbutton ? Center(
                          child: Padding(padding: EdgeInsets.all(30),
                            child:
                            Text(
                              "Veuillez cliquez sur le boutton ci-dessus pour vous connectez.",
                              maxLines: 4,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                            ),
                          ),
                        ) : SizedBox()


                       /* CustomButton(
                          onTap: () => widget.loginInteractor
                              .loginWithMobile(isoCode, _login.text),
                          text:  getString(Strings.SIGN_UP),
                        ),*/
                      ],
                    ),
                  ),
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


  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login() async {
    try {
    await  Constante.gpsPermission();

      position=await Constante.determinePosition();
      await oauth.login();
      EasyLoading.show(status: 'Connexion en cours...');
      var accessToken = await oauth.getAccessToken();
      //showMessage('Logged in successfully, your access token: $accessToken');
      if( accessToken.toString().isNotEmpty){
        setState(() {
          showbutton=false;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken.toString());
        final String? token = prefs.getString('token');
        print(token.toString());
        await openSession(token!);
      }else{
        EasyLoading.dismiss();
        EasyLoading.showError('Echèc de la connexion', duration: Duration(seconds: 5));
      }
    } catch (e) {
      print("erreur : $e");
      EasyLoading.dismiss();
      EasyLoading.showError('Echèc de la connexion', duration: Duration(seconds: 5));
      setState(() {
        showbutton=true;
      });
    }
  }

}



/*static final Config config = Config(
      clientId: "c4ecfd77-dd42-41be-8a92-ec551b93b974",
      tenant: "exob2ctapreprod",
      scope: "https://exob2ctapreprod.onmicrosoft.com/c69f59a9-6f3d-4337-b6a3-401a12c5ec77/user_impersonation",
      redirectUri: 'https://login.live.com/oauth20_desktop.srf',
      //redirectUri: "https://exob2ctapreprod.b2clogin.com/oauth2/nativeclient",
      clientSecret: "jII8Q~21OKd.8XcyypkTZ4uUUWk3jaE.pe45HdAR",
      isB2C: true,
      policy: "B2C_1_ApiTransportLogin",
      //tokenIdentifier: "UNIQUE IDENTIFIER A"
  );*/



/*static final Config config = Config(
   tenant: '4717ebd5-fab0-4967-aebc-c3e605d17843',
    clientId: '5dc4e588-5814-4c61-ae03-f4695cc7507e',
    scope: '4f94bea8-c14f-48b3-979f-322581bac86d',
    redirectUri: 'https://login.live.com/oauth20_desktop.srf',
      clientSecret: "yWK8Q~HsjFoUbnmiBy8Or9L~4PmZiH9wtCvm3akc",
      isB2C: true,
     // policy: "YOUR_USER_FLOW___USER_FLOW_A",
      //tokenIdentifier: "UNIQUE IDENTIFIER A"
    // valeur du client secret: yWK8Q~HsjFoUbnmiBy8Or9L~4PmZiH9wtCvm3akc
  );*/

/* static final Config config = new Config(
      tenant: "4717ebd5-fab0-4967-aebc-c3e605d17843",
      clientId: "5dc4e588-5814-4c61-ae03-f4695cc7507e",
      scope: "4f94bea8-c14f-48b3-979f-322581bac86d",
      redirectUri: "https://login.live.com/oauth20_desktop.srf",
      clientSecret: "yWK8Q~HsjFoUbnmiBy8Or9L~4PmZiH9wtCvm3akc",
      isB2C: true,
     // policy: "YOUR_USER_FLOW___USER_FLOW_A",
     // tokenIdentifier: "UNIQUE IDENTIFIER A"
      );*/



/*static final Config config = new Config(
      tenant: "fabrikamb2c.onmicrosoft.com",
      clientId: "90c0fe63-bcf2-44d5-8fb7-b8bbc0b29dc6",
      scope: "https://fabrikamb2c.b2clogin.com/tfp/fabrikamb2c.onmicrosoft.com/b2c_1_edit_profile/",
      redirectUri: "msauth://com.azuresamples.msalandroidapp/1wIqXSqBj7w%2Bh11ZifsnqwgyKrY%3D",
      //clientSecret: "YOUR_CLIENT_SECRET",
      isB2C: true,
      //tokenIdentifier: "UNIQUE IDENTIFIER A"
  );*/


/// Attributes for Azure B2C ///
/*final clientId = 'b776705b-29e9-4b80-9c5f-4ccee78a7fef';
  final redirectURL = 'com.imaginecup.prodplatform://oauthredirect';
  final discoveryURL =
      'https://prodplatform.b2clogin.com/prodplatform.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1_SignUpSignIn';
  final List<String> scopes = ['b776705b-29e9-4b80-9c5f-4ccee78a7fef','openid', 'profile', ];*/

/*final clientId = 'c4ecfd77-dd42-41be-8a92-ec551b93b974';
  final redirectURL = 'com.flutter.cabira-driver://oauthredirect';
  //final discoveryURL ="https://exob2ctapreprod.b2clogin.com/exob2ctapreprod.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_ApiTransportLogin";
  final discoveryURL = 'https://exob2ctapreprod.b2clogin.com/exob2ctapreprod.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1_ApiTransportLogin';
  final List<String> scopes = ['https://exob2ctapreprod.onmicrosoft.com/c69f59a9-6f3d-4337-b6a3-401a12c5ec77/user_impersonation'];

  late SharedPreferences prefs;*/

