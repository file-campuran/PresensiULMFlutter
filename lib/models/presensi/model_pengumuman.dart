// To parse this JSON data, do
//
//     final pengumumanModel = pengumumanModelFromJson(jsonString);

import 'dart:convert';
import 'package:absen_online/utils/utils.dart';

PengumumanModel pengumumanModelFromJson(String str) =>
    PengumumanModel.fromJson(json.decode(str));

String pengumumanModelToJson(PengumumanModel data) =>
    json.encode(data.toJson());

class PengumumanModel {
  PengumumanModel({
    this.id,
    this.isRead,
    this.tgl,
    this.judul,
    this.konten,
  });

  int isRead;
  String id;
  String tgl;
  String judul;
  String konten;

  factory PengumumanModel.fromJson(Map<String, dynamic> json) =>
      PengumumanModel(
        id: json["id"],
        isRead: json["isRead"] ?? 0,
        tgl: json["tgl"],
        judul: json["judul"],
        konten: json["konten"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isRead": isRead,
        "tgl": tgl,
        "judul": judul,
        "konten": konten,
      };

  String humanDate() {
    try {
      return unixTimeStampToDateTime(
          DateTime.parse(tgl).millisecondsSinceEpoch);
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
