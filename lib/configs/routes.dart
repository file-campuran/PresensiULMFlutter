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
  static const String pengumumanDetail = "/pengumumanDetail";
  static const String version = "/version";
  static const String hariLibur = "/hariLibur";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case privacyPolicy:
        return CustomRoutes(page: PrivacyPolicy());

      case panduan:
        return CustomRoutes(page: Panduan());

      case hariLibur:
        return CustomRoutes(page: HariLibur());

      case notification:
        return CustomRoutes(page: NotificationList());

      case detailNotification:
        final args = settings.arguments;

        return CustomRoutes(
            page: DetailNotification(
          item: args,
        ));

      case riwayatDetail:
        final args = settings.arguments;
        return CustomRoutes(
            page: RiwayatDetail(
          item: args,
        ));

      case editProfile:
        final leading = settings.arguments;
        return CustomRoutes(page: EditProfile(leading: leading));

      case changeLanguage:
        return CustomRoutes(page: LanguageSetting());

      case themeSetting:
        return CustomRoutes(page: ThemeSetting());

      case setting:
        return CustomRoutes(page: Setting());

      case fontSetting:
        return CustomRoutes(page: FontSetting());

      case location:
        final location = settings.arguments;
        return CustomRoutes(
          page: Location(
            location: location,
          ),
        );

      case locationPicker:
        return CustomRoutes(
          page: LocationPicker(),
        );

      case gallery:
        final photo = settings.arguments;
        return CustomRoutes(
          page: Gallery(photo: photo),
          fullscreenDialog: true,
        );

      case photoPreview:
        final Map<String, dynamic> params = settings.arguments;
        return CustomRoutes(
          page: PhotoPreview(
            galleryList: params['photo'],
            initialIndex: params['index'],
          ),
          fullscreenDialog: true,
        );

      case messageDetail:
        final args = settings.arguments;
        return CustomRoutes(
          page: MessageDetailScreen(
            message: args,
          ),
          fullscreenDialog: true,
        );

      case pengumumanDetail:
        final args = settings.arguments;
        return CustomRoutes(
          page: PengumumanDetailScreen(
            message: args,
          ),
          fullscreenDialog: true,
        );

      case faq:
        return CustomRoutes(page: Faq());

      case version:
        return CustomRoutes(page: Version());

      default:
        return CustomRoutes(
          page: Scaffold(
            appBar: AppBar(
              title: Text("Not Found"),
            ),
            body: Center(
              child: Text('No path for ${settings.name}'),
            ),
          ),
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

class CustomRoutes extends PageRouteBuilder {
  final Widget page;
  final bool fullscreenDialog;
  CustomRoutes({this.page, this.fullscreenDialog = false})
      : super(
          fullscreenDialog: fullscreenDialog,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
