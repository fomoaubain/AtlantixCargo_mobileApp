import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Assets/assets.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Components/entry_field.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'bank-details_interactor.dart';
import 'package:qcabs_driver/Locale/locale.dart';

class BankDetailsUI extends StatefulWidget {
  final BankDetailsInteractor bankDetailsInteractor;

  BankDetailsUI(this.bankDetailsInteractor);

  @override
  _BankDetailsUIState createState() => _BankDetailsUIState();
}

class _BankDetailsUIState extends State<BankDetailsUI> {
  TextEditingController _accNumberController =
      TextEditingController(text: '5555 5555 5555 5555');
  TextEditingController _bankNameController =
      TextEditingController(text: 'New York Bank');
  TextEditingController _bankCodeController =
      TextEditingController(text: 'BNY45121');

  @override
  void dispose() {
    _accNumberController.dispose();
    _bankNameController.dispose();
    _bankCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Container(
                height: size.height + 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(),
                    SizedBox(height: 12,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Image.asset(
                        Assets.Logo,
                        height: 72,
                        alignment: AlignmentDirectional.centerStart,
                      ),
                    ),
                    SizedBox(height: 12,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        getString(Strings.ENTER_BANK_DETAILS)!,
                        style: theme.textTheme.headline4,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        getString(Strings.YOU_WILL_GET)!,
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: theme.hintColor),
                      ),
                    ),
                    SizedBox(height: 12,),
                    Expanded(
                      child: Container(
                        // height: MediaQuery.of(context).size.height * 0.61,
                        color: theme.backgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 20,),
                            EntryField(
                              controller: _accNumberController,
                              label: getString(Strings.ACC_NUM),
                            ),
                            EntryField(
                              controller: _bankNameController,
                              label: getString(Strings.BANK_NAME),
                            ),
                            EntryField(
                              controller: _bankCodeController,
                              label: getString(Strings.BANK_CODE),
                            ),
                            SizedBox(height: 50,),
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
                    text: getString(Strings.SKIP),
                    onTap: () => widget.bankDetailsInteractor.skip(),
                    color: theme.scaffoldBackgroundColor,
                    textColor: theme.primaryColor,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    text: getString(Strings.ADD_BANK),
                    onTap: () =>
                        widget.bankDetailsInteractor.addBank(),
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
