import 'package:absen_online/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
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
