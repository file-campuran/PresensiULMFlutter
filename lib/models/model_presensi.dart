// To parse this JSON data, do
//
//     final presensi = presensiFromJson(jsonString);

import 'dart:convert';

PresensiModel presensiModelFromJson(String str) =>
    PresensiModel.fromJson(json.decode(str));

String presensiModelToJson(PresensiModel data) => json.encode(data.toJson());

class PresensiListModel {
  List<PresensiModel> list;

  PresensiListModel(this.list);

  factory PresensiListModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorList = json['rows'] ?? [];

    final list = refactorList.map((item) {
      return PresensiModel.fromJson(item);
    }).toList();

    return PresensiListModel(list);
  }
}

class PresensiModel {
  PresensiModel({
    this.id,
    this.user,
    this.tanggal,
    this.status,
    this.lokasi,
    this.latitude,
    this.longitude,
    this.fileGambar,
    this.fileBerkas,
    this.deskripsiKinerja,
    this.deviceIsIos,
    this.deviceIsRoot,
    this.deviceIsFakeGps,
    this.isMudik,
    this.deviceInfo,
    this.createAt,
    this.updateAt,
  });

  String id;
  String user;
  DateTime tanggal;
  String status;
  String lokasi;
  double latitude;
  double longitude;
  String fileGambar;
  String fileBerkas;
  String deskripsiKinerja;
  String deviceIsIos;
  String deviceIsRoot;
  String deviceIsFakeGps;
  String isMudik;
  dynamic deviceInfo;
  DateTime createAt;
  DateTime updateAt;

  factory PresensiModel.fromJson(Map<String, dynamic> json) => PresensiModel(
        id: json["id"],
        user: json["user"],
        tanggal: DateTime.parse(json["tanggal"]),
        status: json["status"],
        lokasi: json["lokasi"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
        fileGambar:
            'https://presensi.ulm.ac.id/pwa/getImage/${json["fileGambar"]}',
        fileBerkas: json["fileBerkas"],
        deskripsiKinerja: json["deskripsiKinerja"],
        deviceIsIos: json["deviceIsIos"],
        deviceIsRoot: json["deviceIsRoot"],
        deviceIsFakeGps: json["deviceIsFakeGps"],
        isMudik: json["isMudik"],
        deviceInfo: json["deviceInfo"],
        createAt: DateTime.parse(json["createAt"]),
        updateAt: DateTime.parse(json["updateAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "tanggal": tanggal.toIso8601String(),
        "status": status,
        "lokasi": lokasi,
        "latitude": latitude,
        "longitude": longitude,
        "fileGambar": fileGambar,
        "fileBerkas": fileBerkas,
        "deskripsiKinerja": deskripsiKinerja,
        "deviceIsIos": deviceIsIos,
        "deviceIsRoot": deviceIsRoot,
        "deviceIsFakeGps": deviceIsFakeGps,
        "isMudik": isMudik,
        "deviceInfo": deviceInfo,
        "createAt": createAt.toIso8601String(),
        "updateAt": updateAt.toIso8601String(),
      };
}
