import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Components/entry_field.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'verification_interactor.dart';
import 'package:qcabs_driver/Locale/locale.dart';

class VerificationUI extends StatefulWidget {
  final VerificationInteractor verificationInteractor;

  VerificationUI(this.verificationInteractor);

  @override
  _VerificationUIState createState() => _VerificationUIState();
}

class _VerificationUIState extends State<VerificationUI> {
  final TextEditingController _otpController =
      TextEditingController(text: '587652');

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top +120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        getString(Strings.ENTER)! +
                            '\n' +
                            getString(Strings.VER_CODE)!,
                        style: theme.textTheme.headline4,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        getString(Strings.ENTER_CODE_WE)!,
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: theme.hintColor),
                      ),
                    ),
                    SizedBox(height: 48,),
                    Expanded(
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.7,
                        color: theme.backgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Spacer(),
                            EntryField(
                              controller: _otpController,
                              label: getString(Strings.ENTER_6_DIGIT),
                            ),
                            Spacer(flex: 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: getString(Strings.NOT_RECEIVED),
                    onTap: () =>
                        widget.verificationInteractor.notReceived(),
                    color: theme.scaffoldBackgroundColor,
                    textColor: theme.primaryColor,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onTap: () =>
                        widget.verificationInteractor.verify(),
                  ),
                ),
              ],
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
