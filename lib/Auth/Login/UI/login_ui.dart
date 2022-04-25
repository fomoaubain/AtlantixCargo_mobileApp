import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Components/entry_field.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'login_interactor.dart';
import 'package:qcabs_driver/Locale/locale.dart';

class LoginUI extends StatefulWidget {
  final LoginInteractor loginInteractor;

  LoginUI(this.loginInteractor);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final TextEditingController _login =
      TextEditingController(text: '');
  final TextEditingController _password =
  TextEditingController(text: '');

  String isoCode = '';

  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Spacer(),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: (width/12)),
                          child:Center(
                            child: EntryField(
                              suffixIcon: Icons.account_circle,
                              controller: _login,
                              label: getString(Strings.ENTER_LOGIN),
                            ),
                          )
                      ),
                      Spacer(),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: (width/12)),
                          child:Center(
                            child:  EntryField(
                              suffixIcon: Icons.lock,
                              controller: _password,
                              label: getString(Strings.ENTER_PASSWORD),
                            ),
                          )
                      ),

                      Spacer(flex: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(getString(Strings.FORGET_PASSWORD)!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15
                              ),),
                          ),
                          InkWell(
                            onTap: () {
                            },
                            child: Text(getString(Strings.CLIQ_HERE)!, style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15, color: Theme.of(context).hintColor
                            ),),
                          ),

                        ],
                      ),
                      Spacer(flex: 3),
                      CustomButton(
                        onTap: () => widget.loginInteractor
                            .loginWithMobile(isoCode, _login.text),
                        text:  getString(Strings.SIGN_UP),
                      ),
                    ],
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
}
