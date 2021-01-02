// To parse this JSON data, do
//
//     final jadwalModel = jadwalModelFromJson(jsonString);

import 'dart:convert';
import 'model_presensi.dart';
import 'package:absen_online/utils/utils.dart';

JadwalListModel jadwalListModelFromJson(String str) =>
    JadwalListModel.fromJson(json.decode(str));

String jadwalModelToJson(JadwalModel data) => json.encode(data.toJson());

class JadwalListModel {
  List<JadwalModel> list;

  JadwalListModel(this.list);

  factory JadwalListModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorList = json != null ? json['rows'] : [];

    final list = refactorList.map((item) {
      return JadwalModel.fromJson(item);
    }).toList();

    return JadwalListModel(list);
  }
}

class JadwalModel {
  JadwalModel({
    this.timeLeft,
    this.ruleId,
    this.ruleRole,
    this.ruleStatus,
    this.ruleStartTime,
    this.ruleEndTime,
    this.ruleCreateAt,
    this.ruleUpdateAt,
    this.ruleIsUploadFile,
    this.ruleIsSifatUploadFile,
    this.presensi,
  });

  String timeLeft;
  String ruleId;
  String ruleRole;
  String ruleStatus;
  String ruleStartTime;
  String ruleEndTime;
  DateTime ruleCreateAt;
  DateTime ruleUpdateAt;
  String ruleIsUploadFile;
  String ruleIsSifatUploadFile;
  PresensiModel presensi;

  factory JadwalModel.fromJson(Map<String, dynamic> json) => JadwalModel(
        timeLeft: sisaWaktu(json["ruleStartTime"], json["ruleEndTime"]),
        ruleId: json["ruleId"],
        ruleRole: json["ruleRole"],
        ruleStatus: json["ruleStatus"],
        ruleStartTime: json["ruleStartTime"],
        ruleEndTime: json["ruleEndTime"],
        ruleCreateAt: DateTime.parse(json["ruleCreateAt"]),
        ruleUpdateAt: DateTime.parse(json["ruleUpdateAt"]),
        ruleIsUploadFile: json["ruleIsUploadFile"],
        ruleIsSifatUploadFile: json["ruleIsSifatUploadFile"],
        presensi: json['presensi'] == false
            ? null
            : PresensiModel.fromJson(json['presensi']),
      );

  Map<String, dynamic> toJson() => {
        "ruleId": ruleId,
        "ruleRole": ruleRole,
        "ruleStatus": ruleStatus,
        "ruleStartTime": ruleStartTime,
        "ruleEndTime": ruleEndTime,
        "ruleCreateAt": ruleCreateAt.toIso8601String(),
        "ruleUpdateAt": ruleUpdateAt.toIso8601String(),
        "ruleIsUploadFile": ruleIsUploadFile,
        "ruleIsSifatUploadFile": ruleIsSifatUploadFile,
        "presensi": presensi,
      };
}
