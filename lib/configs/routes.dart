import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/screens/screen.dart';

class Routes {
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String forgotPassword = "/forgotPassword";
  static const String productDetail = "/productDetail";
  static const String productDetailTab = "ProductDetailTab";
  static const String searchHistory = "/searchHistory";
  static const String category = "/category";
  static const String editProfile = "/editProfile";
  static const String changePassword = "/changePassword";
  static const String changeLanguage = "/changeLanguage";
  static const String contactUs = "/contactUs";
  static const String chat = "/chat";
  static const String aboutUs = "/aboutUs";
  static const String gallery = "/gallery";
  static const String photoPreview = "/photoPreview";
  static const String themeSetting = "/themeSetting";
  static const String listProduct = "/listProduct";
  static const String filter = "/filter";
  static const String review = "/review";
  static const String writeReview = "/writeReview";
  static const String location = "/location";
  static const String setting = "/setting";
  static const String fontSetting = "/fontSetting";
  static const String chooseLocation = "/chooseLocation";
  static const String faq = "/faq";
  static const String privacyPolicy = "/privacyPolicy";
  static const String panduan = "/panduan";
  static const String riwayatDetail = "/riwayatDetail";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (context) {
            return SignIn();
          },
        );

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

      case riwayatDetail:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return RiwayatDetail(
              item: args,
            );
          },
        );

      case productDetail:
        final id = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return ProductDetail(id: '1');
          },
        );

      case productDetailTab:
        final id = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return ProductDetailTab(id: id);
          },
        );

      case searchHistory:
        return MaterialPageRoute(
          builder: (context) => SearchHistory(),
          fullscreenDialog: true,
        );

      case category:
        return MaterialPageRoute(
          builder: (context) {
            return Category();
          },
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return EditProfile();
          },
        );

      case changePassword:
        return MaterialPageRoute(
          builder: (context) {
            return ChangePassword();
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

      case filter:
        return MaterialPageRoute(
          builder: (context) => Filter(),
          fullscreenDialog: true,
        );

      case review:
        return MaterialPageRoute(
          builder: (context) {
            return Review();
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

      case listProduct:
        final category = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return ListProduct(title: category);
          },
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

      case chooseLocation:
        final location = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return ChooseLocation(location: location);
          },
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
