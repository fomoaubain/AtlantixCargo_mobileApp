import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Components/entry_field.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'registration_interactor.dart';
import 'package:qcabs_driver/Locale/locale.dart';

class RegistrationUI extends StatefulWidget {
  final RegistrationInteractor registrationInteractor;
  final String? phoneNumber;

  RegistrationUI(this.registrationInteractor, this.phoneNumber);

  @override
  _RegistrationUIState createState() => _RegistrationUIState();
}

class _RegistrationUIState extends State<RegistrationUI> {
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
                            getString(Strings.SIGN_UP_NOW)!,
                            style: theme.textTheme.headline4,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Text(
                            getString(Strings.ENTER_REQ_INFO)!,
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
                      top: 120,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Icon(Icons.camera_alt, color: theme.backgroundColor),
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
                          initialValue: widget.phoneNumber,
                          readOnly: true,
                        ),
                        EntryField(
                          controller: _nameController,
                          label: getString(Strings.FULL_NAME),
                        ),
                        EntryField(
                          controller: _emailController,
                          label: getString(Strings.EMAIL_ADD),
                        ),
                        SizedBox(height: 28),
                        Divider(
                          color: theme.scaffoldBackgroundColor,
                          thickness: 20,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            getString(Strings.CAR_INFO)!,
                            style: theme.textTheme.headline4,
                          ),
                        ),
                        EntryField(
                          label: getString(Strings.CAR_BRAND),
                          hint: getString(Strings.SELECT_CAR_BRAND),
                          suffixIcon: Icons.arrow_drop_down,
                          readOnly: true,
                        ),
                        EntryField(
                          label: getString(Strings.CAR_MODEL),
                          hint: getString(Strings.SELECT_CAR_MODEL),
                          suffixIcon: Icons.arrow_drop_down,
                          readOnly: true,
                        ),
                        EntryField(
                          label: getString(Strings.VEHICLE_NUM),
                          hint: getString(Strings.ENTER_VEHICLE_NUM),
                        ),
                        SizedBox(height: 20),
                        Divider(
                          color: theme.scaffoldBackgroundColor,
                          thickness: 20,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            getString(Strings.DOCUMENT)!,
                            style: theme.textTheme.headline4,
                          ),
                        ),
                        EntryField(
                          label: getString(Strings.ID_VER),
                          hint: getString(Strings.UPLOAD_VER_DOC),
                          suffixIcon: Icons.upload_rounded,
                          readOnly: true,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  text: getString(Strings.UPDATE_INFO),
                  onTap: () => widget.registrationInteractor
                      .register(_nameController.text, _emailController.text),
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
