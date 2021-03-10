// To parse this JSON data, do
//
//     final EventModel = EventModelFromJson(jsonString);

import 'dart:convert';
import 'package:absen_online/utils/utils.dart';

EventListModel eventListModelFromJson(String str) =>
    EventListModel.fromJson(json.decode(str));

EventModel eventModelFromJson(String str) =>
    EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventListModel {
  List<EventModel> list;

  EventListModel(this.list);

  factory EventListModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorList = json != null ? json['rows'] : [];

    final list = refactorList.map((item) {
      return EventModel.fromJson(item);
    }).toList();

    return EventListModel(list);
  }
}

class EventModel {
  EventModel({
    this.id,
    this.nama,
    this.tanggal,
    this.tanggalManusia,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String nama;
  DateTime tanggal;
  String tanggalManusia;
  String keterangan;
  DateTime createdAt;
  DateTime updatedAt;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        nama: json["nama"],
        tanggal: DateTime.parse(json["tanggal"]),
        tanggalManusia: unixTimeStampToDateDocs(
            DateTime.parse(json["tanggal"]).millisecondsSinceEpoch),
        keterangan: json["keterangan"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "keterangan": keterangan,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
