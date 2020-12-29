import 'package:absen_online/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static bool debug = true;
  static String version = '2.0.0';
  static int versionCode = 11;
  static SharedPreferences preferences;
  static UserModel user;
  static String pushToken;
  static ConfigModel remoteConfig;

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
