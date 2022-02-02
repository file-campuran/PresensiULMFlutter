// To parse this JSON data, do
//
//     final kecamatanListModel = kecamatanListModelFromMap(jsonString);

import 'dart:convert';
import 'dart:math';

import 'dart:ui';

class KecamatanListModel {
  KecamatanListModel({
    this.rows,
  });

  final List<KecamatanModel> rows;

  factory KecamatanListModel.fromJson(String str) =>
      KecamatanListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KecamatanListModel.fromMap(Map<String, dynamic> json) =>
      KecamatanListModel(
        rows: json["rows"] == null
            ? null
            : List<KecamatanModel>.from(
                json["rows"].map((x) => KecamatanModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows.map((x) => x.toMap())),
      };
}

class KecamatanModel {
  KecamatanModel({
    this.kode,
    this.nama,
    this.kabKota,
    this.kordinat,
    this.color,
    this.isValid,
  });

  final String kode;
  final String nama;
  final String kabKota;
  final List kordinat;
  final Color color;
  final String isValid;

  factory KecamatanModel.fromJson(String str) =>
      KecamatanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KecamatanModel.fromMap(Map<String, dynamic> data) => KecamatanModel(
        kode: data["kode"] == null ? null : data["kode"],
        nama: data["nama"] == null ? null : data["nama"],
        kabKota: data["kabKota"] == null ? null : data["kabKota"],
        kordinat: data["kordinat"] == null
            ? null
            : json.decode(data["kordinat"].toString()),
        isValid: data["isValid"] == null ? null : data["isValid"],
        color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
            Random().nextInt(255), 1),
      );

  Map<String, dynamic> toMap() => {
        "kode": kode == null ? null : kode,
        "nama": nama == null ? null : nama,
        "kabKota": kabKota == null ? null : kabKota,
        "kordinat": kordinat == null ? null : kordinat,
        "isValid": isValid == null ? null : isValid,
        "color": color == null ? null : color,
      };
}
