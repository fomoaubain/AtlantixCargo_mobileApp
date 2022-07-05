import 'package:flutter/material.dart';
import 'package:qcabs_driver/Auth/Login/UI/login_page.dart';
import 'package:qcabs_driver/BookRide/StepperPage.dart';
import 'package:qcabs_driver/BookRide/begin_ride.dart';
import 'package:qcabs_driver/BookRide/ride_booked_page.dart';
import 'package:qcabs_driver/DrawerPages/Historique/details_page.dart';
import 'package:qcabs_driver/DrawerPages/Historique/historique_page.dart';
import 'package:qcabs_driver/DrawerPages/Home/notification_page.dart';
import 'package:qcabs_driver/DrawerPages/Home/offline_page.dart';
import 'package:qcabs_driver/DrawerPages/Profile/my_profile.dart';
import 'package:qcabs_driver/DrawerPages/Profile/reviews.dart';
import 'package:qcabs_driver/DrawerPages/Rides/my_rides_page.dart';
import 'package:qcabs_driver/DrawerPages/Rides/ride_info_page.dart';
import 'package:qcabs_driver/DrawerPages/Settings/settings_page.dart';
import '../DrawerPages/ContactUs/contact_us_page.dart';
import '../DrawerPages/Insight/insight_page.dart';
import '../DrawerPages/PromoCode/promo_code_page.dart';
import '../DrawerPages/Wallet/send_to_bank_page.dart';
import '../DrawerPages/Wallet/wallet_page.dart';
import '../DrawerPages/faq_page.dart';

class PageRoutes {
  static const String offlinePage = 'offline_page';
  static const String rideBookedPage = 'ride_booked_page';
  static const String beginRide = 'begin_ride';
  static const String insightPage = 'insight_page';
  static const String myRidesPage = 'my_ride_page';
  static const String rideInfoPage = 'ride_info_page';
  static const String sendToBank = 'send_to_bank';
  static const String walletPage = 'wallet_page';
  static const String reviewsPage = 'review_page';
  static const String myProfilePage = 'profile_page';
  static const String promoCode = 'promo_code';
  static const String contactUsPage = 'contact_us';
  static const String faqPage = 'faq_page';
  static const String settingsPage = 'settings_page';
  static const String stepperPage = 'stepper_page';
  static const String historiquePage = 'historique_page';
  static const String notificationPage = 'notification_page';
  static const String detailsPage = 'details_page';
  static const String loginPage = 'login_page';

  Map<String, WidgetBuilder> routes() {
    return {
      offlinePage: (context) => OfflinePage(),
      rideBookedPage: (context) => RideBookedPage(),
      beginRide: (context) => BeginRide(),
      insightPage: (context) => InsightPage(),
      myRidesPage: (context) => MyRidesPage(),
      rideInfoPage: (context) => RideInfoPage(),
      sendToBank: (context) => SendToBankPage(),
      walletPage: (context) => WalletPage(),
      reviewsPage: (context) => ReviewsPage(),
      myProfilePage: (context) => MyProfilePage(),
      promoCode: (context) => PromoCodePage(),
      contactUsPage: (context) => ContactUsPage(),
      faqPage: (context) => FaqPage(),
      settingsPage: (context) => SettingsPage(),
     // stepperPage: (context) => StepperPage(null),
      historiquePage: (context) => HistoriquePage(),
      notificationPage: (context) => NotificationPage(),
      detailsPage: (context) => DetailsPage(),
      loginPage: (context) => LoginPage(),
    };
  }
}
