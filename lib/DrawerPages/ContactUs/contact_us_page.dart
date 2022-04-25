import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Components/entry_field.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import '../app_drawer.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      drawer: AppDrawer(false),
      body: FadedSlideAnimation(
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height + 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        context.getString(Strings.CONTACT_US)!,
                        style: theme.textTheme.headline5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text(
                        context.getString(Strings.ENTER_PROMO_CODE_TO)!,
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: theme.hintColor),
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            icon: Icons.call,
                            text: context.getString(Strings.CALL_US),
                            color: theme.cardColor,
                            textColor: theme.primaryColor,
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            icon: Icons.email,
                            text: context.getString(Strings.EMAIL_US),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: theme.backgroundColor,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(24, 48, 24, 0),
                                child: Text(
                                  context.getString(Strings.WRITE_US)!,
                                  style: theme.textTheme.headline5,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                child: Text(
                                  context.getString(Strings.DESC_YOUR_ISSUE)!,
                                  style: theme.textTheme.bodyText2!
                                      .copyWith(color: theme.hintColor),
                                ),
                              ),
                              SizedBox(height: 20),
                              EntryField(
                                label: getString(Strings.YOUR_EMAIL),
                                initialValue: 'samsmith@mail.com',
                              ),
                              SizedBox(height: 20),
                              EntryField(
                                controller: _controller,
                                label: getString(Strings.DESC_YOUR_ISSUE),
                              ),
                              // Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              child: CustomButton(
                text: context.getString(Strings.SUBMIT),
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
