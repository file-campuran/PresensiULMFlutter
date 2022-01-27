import 'package:absen_online/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class Application {
  static SharedPreferences preferences;
  static Database db;
  static UserModel user;
  static LokasiPresensiListModel lokasiPresensiList;
  static String pushToken;
  static ConfigModel remoteConfig;

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
