import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import '../../Assets/assets.dart';
import '../../Components/custom_button.dart';
import '../../Components/entry_field.dart';
import '../../Locale/strings_enum.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  TextEditingController _nameController =
      TextEditingController(text: 'Sam Smith');
  TextEditingController _emailController =
      TextEditingController(text: 'samsmith@mail.com');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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
                              Icons.camera_alt,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              getString(Strings.CHANGE_PICTURE)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
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
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        EntryField(
                          label: getString(Strings.ENTER_PHONE),
                          initialValue: '+1 987 654 3210',
                          readOnly: true,
                        ),
                        EntryField(
                          label: getString(Strings.FULL_NAME),
                          initialValue: 'George Smith',
                        ),
                        EntryField(
                          label: getString(Strings.EMAIL_ADD),
                          initialValue: 'georgesmith@mail.com',
                        ),
                        SizedBox(height: 28),




                      ],
                    ),
                  ),
                ),
                CustomButton(
                  text: "Sauvegarder",
                  // onTap: () => widget.registrationInteractor
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
