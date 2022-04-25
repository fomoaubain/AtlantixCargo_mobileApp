import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/DrawerPages/Settings/theme_cubit.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'language_cubit.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late LanguageCubit _languageCubit;
  late ThemeCubit _themeCubit;
  int? _themeValue;
  int? _languageValue;

  @override
  void initState() {
    super.initState();
    _themeValue = 0;
    _languageValue = 0;
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final List<Strings> themes = [Strings.LIGHT_MODE, Strings.DARK_MODE];
    final List<Strings> languages = [
      Strings.ENGLISH,
      Strings.FRENCH,
    ];
    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        Stack(
          children: [
            ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    getString(Strings.SETTINGS)!,
                    style: theme.textTheme.headline5,
                  ),
                ),
               /* Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    context.getString(Strings.CHOOSE_THEME)!,
                    style: theme.textTheme.bodyText2!
                        .copyWith(color: theme.hintColor),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: themes.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => RadioListTile(
                    activeColor: theme.primaryColor,
                    value: index,
                    groupValue: _themeValue,
                    onChanged: (dynamic value) {
                      setState(() {
                        _themeValue = value;
                      });
                    },
                    title: Text(getString(themes[index])!),
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    context.getString(Strings.CHOOSE_LANG)!,
                    style: theme.textTheme.bodyText2!
                        .copyWith(color: theme.hintColor),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: languages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => RadioListTile(
                    activeColor: theme.primaryColor,
                    value: index,
                    groupValue: _languageValue,
                    onChanged: (dynamic value) {
                      setState(() {
                        _languageValue = value;
                      });
                    },
                    title: Text(getString(languages[index])!),
                  ),
                ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: CustomButton(
                text: getString(Strings.SUBMIT),
                onTap: () async {
                  var prefs = await SharedPreferences.getInstance();

                  if (themes[_themeValue!] == Strings.LIGHT_MODE) {
                    prefs.setBool('theme', false);
                    _themeCubit.selectLightTheme();
                  } else if (themes[_themeValue!] == Strings.DARK_MODE) {
                    prefs.setBool('theme', false);
                    _themeCubit.selectDarkTheme();
                  }
                  if (languages[_languageValue!] == Strings.ENGLISH) {
                    prefs.setString('locale', 'en');
                    _languageCubit.selectEngLanguage();
                  }  else if (languages[_languageValue!] == Strings.FRENCH) {
                    prefs.setString('locale', 'fr');
                    _languageCubit.selectFrenchLanguage();
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
