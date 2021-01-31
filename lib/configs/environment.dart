import 'package:flutter/foundation.dart';

class Environment {
  static const bool DEBUG = !kReleaseMode;

  static const String APP_NAME = 'PRESENSI ULM';

  // PRIMARY CONFIGS
  static const String API_URL = 'http://192.168.43.247/api-siapps/public/api';
  static const String API_KEY = '605dafe39ee0780e8cf2c829434eea99';
  static const String API_ID = 'PresensiULM';
  static const int API_TIMEOUT = 20;

  static const String VERSION = '2.0.0 Beta.4.1.2021_B10';
  static const int VERSION_CODE = 11;

  // APP SUPPPORT URL
  static const PRESENSI_IMAGE_URL = 'https://presensi.ulm.ac.id/pwa/getImage';
  static const PRESENSI_FILE_URL = 'https://presensi.ulm.ac.id/pwa/getFile';
  static const PRIVACY_POLICY =
      'https://simari.ulm.ac.id/privacy_policy_presensi.html';
  static const GUIDE =
      'https://cdn01.ovo.id/homepage/public/assets/webview/panduan_ovo.html';

  static const String namaCs = 'Muhammad Nebi Beri Muslim';
  static const String noCs = '+6282149091899';

  ///Singleton factory
  static final Environment _instance = Environment._internal();

  factory Environment() {
    return _instance;
  }

  Environment._internal();
}
