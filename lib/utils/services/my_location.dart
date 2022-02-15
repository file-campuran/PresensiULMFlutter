import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';

import 'dart:convert';

class MyLocationModel {
  MyLocationModel({
    this.status,
    this.message,
  });

  final bool status;
  final String message;

  factory MyLocationModel.fromJson(String str) =>
      MyLocationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyLocationModel.fromMap(Map<String, dynamic> json) => MyLocationModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
      };
}

class MyLocation {
  ///Singleton factory
  static final MyLocation _instance = MyLocation._internal();

  factory MyLocation() {
    return _instance;
  }

  MyLocation._internal();

  Geolocator geolocator = Geolocator();
  Position currentLocation;

  // ignore: close_sinks
  StreamController<Position> _locationController = StreamController<Position>();

  Stream<Position> get locationStream => _locationController.stream;

  Future<Position> getLoacation() async {
    try {
      // Geolocator.checkPermission();
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      UtilLogger.log('ACCURACY LOCATION / Meter', currentLocation.accuracy);

      // if (currentLocation.accuracy > 2500) {
      //   // _locationController.sink.add(currentLocation);
      //   print(currentLocation.accuracy);
      //   return this.getLoacation();
      // }
      // _locationController.sink.add(await getLoacation());
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  MyLocationModel inAreaPresensi(Position position) {
    bool status = false;
    String result = 'Tidak dalam jangkauan titik presensi';

    if (Application.lokasiPresensiList != null) {
      for (var zone in Application.lokasiPresensiList?.list ?? []) {
        double distanceInMeters = Geolocator.distanceBetween(position.latitude,
            position.longitude, zone.latitude, zone.longitude);
        if (distanceInMeters <= zone.radius) {
          status = true;
          // UtilLogger.log('PRESENSI IN AREA', zone.namaLokasi);
          result =
              'Berada dalam area ${zone.namaLokasi} dengan jarak ${distanceInMeters.toStringAsFixed(2)} Meter dari titik presensi';
          result = 'Berada dalam titik presensi yang dibolehkan';
        }
        // UtilLogger.log('DISATANCE BEETWEEN AREA ${zone.namaLokasi} METERS',
        //     distanceInMeters);
      }
    }

    if (Application.kecamatanListModel != null) {
      for (var zone in Application.kecamatanListModel?.rows) {
        if (!status) {
          bool find =
              inside(position.latitude, position.longitude, zone.kordinat);
          if (find) {
            status = true;
            // UtilLogger.log('PRESENSI IN AREA', zone.namaLokasi);
            result = 'Berada dalam area kecamatan ${zone.nama}';
            // result = 'Berada dalam titik presensi yang dibolehkan';
          }
          // UtilLogger.log('DISATANCE BEETWEEN AREA ${zone.namaLokasi} METERS',
          //     distanceInMeters);
        }
      }
    }

    return MyLocationModel(status: status, message: result);
  }

  Future<bool> gpsServiceEnable() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      return true;
    } else {
      return false;
    }
  }

  void closeStream() {
    _locationController.sink.close();
  }

  bool inside(double latitude, double longitude, List vs) {
    // http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
    final x = latitude;
    final y = longitude;

    bool inside = false;
    for (int i = 0, j = vs.length - 1; i < vs.length; j = i++) {
      final xi = double.parse(vs[i][0].toString());
      final yi = double.parse(vs[i][1].toString());
      final xj = double.parse(vs[j][0].toString());
      final yj = double.parse(vs[j][1].toString());

      final intersect =
          ((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
    }

    return inside;
  }
}
