import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/screens/screen.dart';

class Routes {
  static const String editProfile = "/editProfile";
  static const String changeLanguage = "/changeLanguage";
  static const String gallery = "/gallery";
  static const String photoPreview = "/photoPreview";
  static const String themeSetting = "/themeSetting";
  static const String location = "/location";
  static const String locationPicker = "/location_picker";
  static const String setting = "/setting";
  static const String fontSetting = "/fontSetting";
  static const String faq = "/faq";
  static const String privacyPolicy = "/privacyPolicy";
  static const String panduan = "/panduan";
  static const String riwayatDetail = "/riwayatDetail";
  static const String notification = "/notification";
  static const String detailNotification = "/detailNotification";
  static const String messageDetail = "/messageDetail";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case privacyPolicy:
        return MaterialPageRoute(
          builder: (context) {
            return PrivacyPolicy();
          },
        );

      case panduan:
        return MaterialPageRoute(
          builder: (context) {
            return Panduan();
          },
        );

      case notification:
        return MaterialPageRoute(
          builder: (context) {
            return NotificationList();
          },
        );

      case detailNotification:
        final args = settings.arguments;

        return MaterialPageRoute(
          builder: (context) {
            return DetailNotification(
              item: args,
            );
          },
        );

      case riwayatDetail:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return RiwayatDetail(
              item: args,
            );
          },
        );

      case editProfile:
        final leading = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return EditProfile(leading: leading);
          },
        );

      case changeLanguage:
        return MaterialPageRoute(
          builder: (context) {
            return LanguageSetting();
          },
        );

      case themeSetting:
        return MaterialPageRoute(
          builder: (context) {
            return ThemeSetting();
          },
        );

      case setting:
        return MaterialPageRoute(
          builder: (context) {
            return Setting();
          },
        );

      case fontSetting:
        return MaterialPageRoute(
          builder: (context) {
            return FontSetting();
          },
        );

      case location:
        final location = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => Location(
            location: location,
          ),
        );

      case locationPicker:
        return MaterialPageRoute(
          builder: (context) => LocationPicker(),
        );

      case gallery:
        final photo = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => Gallery(photo: photo),
          fullscreenDialog: true,
        );

      case photoPreview:
        final Map<String, dynamic> params = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => PhotoPreview(
            galleryList: params['photo'],
            initialIndex: params['index'],
          ),
          fullscreenDialog: true,
        );

      case messageDetail:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => MessageDetailScreen(
            message: args,
          ),
          fullscreenDialog: true,
        );

      case faq:
        return MaterialPageRoute(
          builder: (context) {
            return Faq();
          },
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
