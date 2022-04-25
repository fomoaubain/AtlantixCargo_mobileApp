import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import 'app_drawer.dart';

class FAQs {
  final Strings title;
  final Strings subtitle;

  FAQs(this.title, this.subtitle);
}

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final List<FAQs> faqs = [
      FAQs(Strings.SIGN_IN_ISSUE, Strings.ISSUE_REG),
      FAQs(Strings.RIDE_BOOKING, Strings.ANY_ISSUE),
      FAQs(Strings.PAYMENT, Strings.PROB_WHILE),
      FAQs(Strings.MAP_LOADING, Strings.MAP_LOADING_ISSUE),
      FAQs(Strings.REPORT_DRIVER, Strings.REPORT_MISBEHAVE),
      FAQs(Strings.OTHER_ISSUE, Strings.WRONG_INFO),
    ];
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(false),
      body: FadedSlideAnimation(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                getString(Strings.FAQS)!,
                style: theme.textTheme.headline4,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                getString(Strings.READ_FAQS)!,
                style:
                    theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                color: theme.backgroundColor,
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  itemCount: faqs.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        title: Text(
                          getString(faqs[index].title)!,
                          style: theme.textTheme.headline6,
                        ),
                        subtitle: Text(getString(faqs[index].subtitle)!),
                        trailing: Icon(
                          Icons.keyboard_arrow_down,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
