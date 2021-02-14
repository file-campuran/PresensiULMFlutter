import 'package:flutter/foundation.dart';

class Environment {
  static const bool DEBUG = true;

  static const String APP_NAME = 'Presensi ULM';
  static const String VERSION = '2.0.0 Beta.4.1.2021_B10';
  static const int VERSION_CODE = 11;

  // PRIMARY CONFIGS
  static String apiUrl = 'http://192.168.43.247/api-siapps/public/api';
  static String apiKey = '605dafe39ee0780e8cf2c829434eea99';
  static String apiId = 'PresensiULM';
  static int apiTimeout = !DEBUG ? 20 : 10;

  // APP SUPPPORT URL
  static String presensiImageUrl = 'https://presensi.ulm.ac.id/pwa/getImage';
  static String presensiFileUrl = 'https://presensi.ulm.ac.id/pwa/getFile';
  static String privacyPolicy =
      'https://simari.ulm.ac.id/privacy_policy_presensi.html';
  static String guide =
      'https://cdn01.ovo.id/homepage/public/assets/webview/panduan_ovo.html';

  static String namaCs = 'Muhammad Nebi Beri Muslim';
  static String noCs = '+6282149091899';

  factory Environment.fromJson(Map<String, dynamic> json) {
    Environment.apiKey = json['key'] ?? Environment.apiKey;
    Environment.apiUrl = json['url'] ?? Environment.apiUrl;
    Environment.apiId = json['id'] ?? Environment.apiId;
    Environment.presensiImageUrl =
        json['presensi_image_url'] ?? Environment.presensiImageUrl;
    Environment.presensiFileUrl =
        json['presensi_file_url'] ?? Environment.presensiFileUrl;
    Environment.privacyPolicy =
        json['privacy_policy_url'] ?? Environment.privacyPolicy;
    Environment.guide = json['guide_url'] ?? Environment.guide;
    Environment.namaCs = json['nama_cs'] ?? Environment.namaCs;
    Environment.noCs = json['no_cs'] ?? Environment.noCs;

    return null;
  }

  ///Singleton factory
  static final Environment _instance = Environment._internal();

  factory Environment() {
    return _instance;
  }

  Environment._internal();
}
