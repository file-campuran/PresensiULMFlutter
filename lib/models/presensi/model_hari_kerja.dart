// To parse this JSON data, do
//
//     final HariKerja = HariKerjaFromJson(jsonString);

import 'dart:convert';

HariKerjaListModel hariKerjaListModelFromJson(String str) =>
    HariKerjaListModel.fromJson(json.decode(str));

HariKerjaModel hariKerjaFromJson(String str) =>
    HariKerjaModel.fromJson(json.decode(str));

String hariKerjaToJson(HariKerjaModel data) => json.encode(data.toJson());

class HariKerjaListModel {
  List<HariKerjaModel> list;

  HariKerjaListModel(this.list);

  factory HariKerjaListModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorList = json != null ? json['rows'] : [];

    final list = refactorList.map((item) {
      return HariKerjaModel.fromJson(item);
    }).toList();

    return HariKerjaListModel(list);
  }
}

class HariKerjaModel {
  HariKerjaModel({
    this.id,
    this.hari,
    this.isLibur,
  });

  String id;
  String hari;
  bool isLibur;

  factory HariKerjaModel.fromJson(Map<String, dynamic> json) => HariKerjaModel(
        id: json["id"],
        hari: json["hari"],
        isLibur: json["isLibur"] == '1',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hari": hari,
        "isLibur": isLibur,
      };
}
