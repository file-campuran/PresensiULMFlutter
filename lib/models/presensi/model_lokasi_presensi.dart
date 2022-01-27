// To parse this JSON data, do
//
//     final lokasiPresensiListModel = lokasiPresensiListModelFromMap(jsonString);

import 'dart:convert';

class LokasiPresensiListModel {
  LokasiPresensiListModel({
    this.list,
  });

  final List<LokasiPresensiModel> list;

  factory LokasiPresensiListModel.fromJson(String str) =>
      LokasiPresensiListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LokasiPresensiListModel.fromMap(Map<String, dynamic> json) =>
      LokasiPresensiListModel(
        list: json["rows"] == null
            ? null
            : List<LokasiPresensiModel>.from(
                json["rows"].map((x) => LokasiPresensiModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "list": list == null
            ? null
            : List<dynamic>.from(list.map((x) => x.toMap())),
      };
}

class LokasiPresensiModel {
  LokasiPresensiModel({
    this.id,
    this.latitude,
    this.longitude,
    this.namaLokasi,
    this.radius,
  });

  final String id;
  final double latitude;
  final double longitude;
  final String namaLokasi;
  final double radius;

  factory LokasiPresensiModel.fromJson(String str) =>
      LokasiPresensiModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LokasiPresensiModel.fromMap(Map<String, dynamic> json) =>
      LokasiPresensiModel(
        id: json["id"] == null ? null : json["id"],
        latitude:
            json["latitude"] == null ? null : double.parse(json["latitude"]),
        longitude:
            json["longitude"] == null ? null : double.parse(json["longitude"]),
        namaLokasi: json["namaLokasi"] == null ? null : json["namaLokasi"],
        radius: json["radius"] == null ? null : double.parse(json["radius"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "namaLokasi": namaLokasi == null ? null : namaLokasi,
        "radius": radius == null ? null : radius,
      };
}
