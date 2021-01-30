// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

ConfigModel configModelFromJson(String str) =>
    ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  ConfigModel({
    this.application,
    this.banner,
  });

  Application application;
  List<String> banner;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        application: Application.fromJson(json["application"]),
        banner: List<String>.from(json["banner"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "application": application.toJson(),
        "banner": List<dynamic>.from(banner.map((x) => x)),
      };
}

class Application {
  Application({
    this.releaseVersion,
    this.minVersion,
    this.upload,
    this.presensi,
    this.update,
  });

  String releaseVersion;
  int minVersion;
  Upload upload;
  Presensi presensi;
  Update update;

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        releaseVersion: json["release_version"],
        minVersion: json["min_version"],
        upload: Upload.fromJson(json["upload"]),
        presensi: Presensi.fromJson(json["presensi"]),
        update: Update.fromJson(json["update"]),
      );

  Map<String, dynamic> toJson() => {
        "release_version": releaseVersion,
        "min_version": minVersion,
        "upload": upload.toJson(),
        "presensi": presensi.toJson(),
        "update": update.toJson(),
      };
}

class Presensi {
  Presensi({
    this.detectFakeGps,
    this.detectFace,
    this.detectFaceRecognition,
    this.showFaceInformation,
  });

  bool detectFakeGps;
  bool detectFace;
  bool detectFaceRecognition;
  bool showFaceInformation;

  factory Presensi.fromJson(Map<String, dynamic> json) => Presensi(
        detectFakeGps: json["detect_fake_gps"],
        detectFace: json["detect_face"],
        detectFaceRecognition: json["detect_face_recognition"],
        showFaceInformation: json["show_face_information"],
      );

  Map<String, dynamic> toJson() => {
        "detect_fake_gps": detectFakeGps,
        "detect_face": detectFace,
        "detect_face_recognition": detectFaceRecognition,
        "show_face_information": showFaceInformation,
      };
}

class Update {
  Update({
    this.iosUrl,
    this.androidUrl,
    this.news,
  });

  String iosUrl;
  String androidUrl;
  List<String> news;

  factory Update.fromJson(Map<String, dynamic> json) => Update(
        iosUrl: json["ios_url"],
        androidUrl: json["android_url"],
        news: List<String>.from(json["news"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ios_url": iosUrl,
        "android_url": androidUrl,
        "news": List<dynamic>.from(news.map((x) => x)),
      };
}

class Upload {
  Upload({
    this.max,
    this.mime,
  });

  String max;
  String mime;

  factory Upload.fromJson(Map<String, dynamic> json) => Upload(
        max: json["max"],
        mime: json["mime"],
      );

  Map<String, dynamic> toJson() => {
        "max": max,
        "mime": mime,
      };
}
