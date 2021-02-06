// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

import 'package:absen_online/configs/environment.dart';

ConfigModel configModelFromJson(String str) =>
    ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  ConfigModel({
    this.presensi,
    this.banner,
    this.update,
    this.environments,
  });

  Environments environments;
  Presensi presensi;
  List<String> banner;
  Update update;

  factory ConfigModel.fromJson(dynamic data) {
    data = data is String ? json.decode(data) : data;

    return ConfigModel(
      presensi: Presensi.fromJson(data["presensi"] is String
          ? json.decode(data["presensi"])
          : data["presensi"]),
      banner: List<String>.from(data["banner"] is String
          ? json.decode(data["banner"])
          : data["banner"].map((x) => x)),
      update: Update.fromJson(data["update"] is String
          ? json.decode(data["update"])
          : data["update"]),
      environments: Environments.fromJson(data["environments"] is String
          ? json.decode(data["environments"])
          : data["environments"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "presensi": presensi.toJson(),
        "banner": List<dynamic>.from(banner.map((x) => x)),
        "update": update.toJson(),
      };
}

class Environments {
  Environments({
    this.key,
    this.url,
    this.id,
    this.timeout,
    this.presensiImageUrl,
    this.presensiFileUrl,
    this.privacyPolicyUrl,
    this.guideUrl,
    this.namaCs,
    this.noCs,
  });

  String key;
  String url;
  String id;
  int timeout;
  String presensiImageUrl;
  String presensiFileUrl;
  String privacyPolicyUrl;
  String guideUrl;
  String namaCs;
  String noCs;

  factory Environments.fromJson(Map<String, dynamic> json) => Environments(
        key: json["key"] ?? Environment.apiKey,
        url: json["url"] ?? Environment.apiUrl,
        id: json["id"] ?? Environment.apiId,
        timeout: json["timeout"] ?? Environment.apiTimeout,
        presensiImageUrl:
            json["presensi_image_url"] ?? Environment.presensiImageUrl,
        presensiFileUrl:
            json["presensi_file_url"] ?? Environment.presensiFileUrl,
        privacyPolicyUrl:
            json["privacy_policy_url"] ?? Environment.privacyPolicy,
        guideUrl: json["guide_url"] ?? Environment.guide,
        namaCs: json["nama_cs"] ?? Environment.namaCs,
        noCs: json["no_cs"] ?? Environment.noCs,
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "url": url,
        "id": id,
        "timeout": timeout,
        "presensi_image_url": presensiImageUrl,
        "presensi_file_url": presensiFileUrl,
        "privacy_policy_url": privacyPolicyUrl,
        "guide_url": guideUrl,
        "nama_cs": namaCs,
        "no_cs": noCs,
      };
}

class Presensi {
  Presensi({
    this.zone,
    this.upload,
    this.detectFakeGps,
    this.detectFace,
    this.detectFaceRecognition,
    this.showFaceInformation,
  });

  List<Zone> zone;
  Upload upload;
  bool detectFakeGps;
  bool detectFace;
  bool detectFaceRecognition;
  bool showFaceInformation;

  factory Presensi.fromJson(Map<String, dynamic> json) => Presensi(
        zone: json["zone"] != null
            ? List<Zone>.from(json["zone"].map((x) => Zone.fromJson(x)))
            : [],
        upload: Upload.fromJson(json["upload"]),
        detectFakeGps: json["detect_fake_gps"],
        detectFace: json["detect_face"],
        detectFaceRecognition: json["detect_face_recognition"],
        showFaceInformation: json["show_face_information"],
      );

  Map<String, dynamic> toJson() => {
        "zone": List<dynamic>.from(zone.map((x) => x.toJson())),
        "upload": upload.toJson(),
        "detect_fake_gps": detectFakeGps,
        "detect_face": detectFace,
        "detect_face_recognition": detectFaceRecognition,
        "show_face_information": showFaceInformation,
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

class Zone {
  Zone({
    this.name,
    this.latitude,
    this.longitude,
    this.radius,
  });

  String name;
  double latitude;
  double longitude;
  int radius;

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        name: json["name"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        radius: json["radius"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "radius": radius,
      };
}

class Update {
  Update({
    this.releaseVersion,
    this.minVersion,
    this.iosUrl,
    this.androidUrl,
    this.news,
  });

  String releaseVersion;
  int minVersion;
  String iosUrl;
  String androidUrl;
  List<String> news;

  factory Update.fromJson(Map<String, dynamic> json) => Update(
        releaseVersion: json["release_version"],
        minVersion: json["min_version"],
        iosUrl: json["ios_url"],
        androidUrl: json["android_url"],
        news: List<String>.from(json["news"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "release_version": releaseVersion,
        "min_version": minVersion,
        "ios_url": iosUrl,
        "android_url": androidUrl,
        "news": List<dynamic>.from(news.map((x) => x)),
      };
}
