import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Components/entry_field.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';

import '../app_drawer.dart';

class SendToBankPage extends StatefulWidget {
  @override
  _SendToBankPageState createState() => _SendToBankPageState();
}

class _SendToBankPageState extends State<SendToBankPage> {
  TextEditingController _bankNameController =
      TextEditingController(text: 'Bank of Nation');
  TextEditingController _accountNumberController =
      TextEditingController(text: '5886 7445 8996 4525');
  TextEditingController _bankCodeController =
      TextEditingController(text: 'VFFC48695');
  TextEditingController _amountController =
      TextEditingController(text: '\$ 100');

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _bankCodeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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
                height: MediaQuery.of(context).size.height + 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        context.getString(Strings.AVAILABLE_AMOUNT)!,
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: theme.hintColor),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '\$ 159.85',
                        style: theme.textTheme.headline4,
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      color: theme.backgroundColor,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 12,),
                          EntryField(
                            controller: _bankNameController,
                            label: getString(Strings.BANK_NAME),
                          ),
                          SizedBox(height: 12,),
                          EntryField(
                            controller: _accountNumberController,
                            label: getString(Strings.ACC_NUM),
                          ),
                          SizedBox(height: 12,),
                          EntryField(
                            controller: _bankCodeController,
                            label: getString(Strings.BANK_CODE),
                          ),
                          SizedBox(height: 12,),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: theme.cardColor,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: EntryField(
                          controller: _amountController,
                          label: getString(Strings.ENTER_AMOUNT_TO_TRANSFER),
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
                onTap: () => Navigator.pop(context),
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
