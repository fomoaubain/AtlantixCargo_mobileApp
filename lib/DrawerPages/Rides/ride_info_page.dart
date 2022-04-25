import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:qcabs_driver/Components/row_item.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import '../../Assets/assets.dart';
import '../../Components/background_image.dart';
import '../../Theme/style.dart';
import 'package:qcabs_driver/Locale/locale.dart';

class RideInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(
      children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(),
          body: FadedSlideAnimation(
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          Assets.User,
                          height: 72,
                          width: 72,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sam Smith',
                            style: theme.textTheme.headline6,
                          ),
                          Spacer(flex: 2),
                          Text(
                            context.getString(Strings.BOOKED_ON)!,
                            style: theme.textTheme.caption,
                          ),
                          Spacer(),
                          Text(
                            context.getString(Strings.YESTERDAY)! + ', 10:25 pm',
                            style: theme.textTheme.bodyText1,
                          ),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.reviewsPage);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppTheme.ratingsColor,
                          ),
                          child: Row(
                            children: [
                              Text('4.2'),
                              SizedBox(width: 4),
                              Icon(
                                Icons.star,
                                color: AppTheme.starColor,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          context.getString(Strings.RIDE_INFO)!,
                          style: theme.textTheme.headline6!
                              .copyWith(color: theme.hintColor, fontSize: 18),
                        ),
                        trailing: Text('08 km',
                            style: theme.textTheme.headline6!
                                .copyWith(fontSize: 18)),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: theme.primaryColor,
                        ),
                        title: Text('2nd ave, World Trade Center'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.navigation,
                          color: theme.primaryColor,
                        ),
                        title: Text('1124, Golden Point Street'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  child: Row(
                    children: [
                      RowItem(
                          context.getString(Strings.PAYMENT_VIA),
                          context.getString(Strings.WALLET),
                          Icons.account_balance_wallet),
                      // Spacer(),
                      RowItem(context.getString(Strings.RIDE_FARE), '\$ 40.50',
                          Icons.account_balance_wallet),
                      // Spacer(),
                      RowItem(context.getString(Strings.RIDE_TYPE),
                          context.getString(Strings.PRIVATE), Icons.drive_eta),
                    ],
                  ),
                ),
              ],
            ),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ),
      ],
    );
  }
}
