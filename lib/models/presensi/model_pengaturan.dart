// To parse this JSON data, do
//
//     final pengaturanListModel = pengaturanListModelFromMap(jsonString);

import 'dart:convert';

class PengaturanListModel {
  PengaturanListModel({
    this.rows,
  });

  final List<PengaturanModel> rows;

  factory PengaturanListModel.fromJson(String str) =>
      PengaturanListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PengaturanListModel.fromMap(Map<String, dynamic> json) =>
      PengaturanListModel(
        rows: json["rows"] == null
            ? null
            : List<PengaturanModel>.from(
                json["rows"].map((x) => PengaturanModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "rows": rows == null
            ? null
            : List<dynamic>.from(rows.map((x) => x.toMap())),
      };

  String getSettingConfig(String key) {
    try {
      return rows.firstWhere((element) => element.key == key).value;
    } catch (e) {
      return '';
    }
  }
}

class PengaturanModel {
  PengaturanModel({
    this.key,
    this.value,
  });

  final String key;
  final String value;

  factory PengaturanModel.fromJson(String str) =>
      PengaturanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PengaturanModel.fromMap(Map<String, dynamic> json) => PengaturanModel(
        key: json["key"] == null ? null : json["key"],
        value: json["value"] == null ? null : json["value"],
      );

  Map<String, dynamic> toMap() => {
        "key": key == null ? null : key,
        "value": value == null ? null : value,
      };
}
