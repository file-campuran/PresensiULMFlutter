import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfig {
  ///Singleton factory
  static final FirebaseRemoteConfig _instance =
      FirebaseRemoteConfig._internal();

  factory FirebaseRemoteConfig() {
    return _instance;
  }

  FirebaseRemoteConfig._internal();

  static Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    try {
      await remoteConfig.fetch(expiration: const Duration(seconds: 1 * 2));
      await remoteConfig.activateFetched();
    } on FetchThrottledException catch (exception) {
      print(exception);
    } catch (exception) {
      print(
          '‘Unable to fetch remote config. Cached or default values will be ‘‘used’');
    }
    remoteConfig.setDefaults(<String, dynamic>{
      'api_url': 'http://google_default.com',
      'api_key': 'api_key_default',
      'image':
          '{"name":"Fischl","image":"https://images7.alphacoders.com/111/1110664.png"}',
      'presensi_config': {
        "api": {
          "url": "https://api.ulm.ac.id",
          "key": "12344",
          "image_location": "https://presensi.ulm.ac.id/image",
          "file_location": "https://presensi.ulm.ac.id/file"
        },
        "config": {
          "version": "2.0.0",
          "min_version": 10,
          "upload": {"max": "213", "mime": "xls|jpg|png"},
          "presensi": {
            "detect_fake_gps": false,
            "detect_face": true,
            "detect_face_recognition": true
          }
        }
      }
    });
    return remoteConfig;
  }
}

class ImageHeader {
  ImageHeader({
    this.name,
    this.image,
  });

  String name;
  String image;

  factory ImageHeader.fromJson(Map<String, dynamic> json) => ImageHeader(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
