import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';

class MyLocation {
  ///Singleton factory
  static final MyLocation _instance = MyLocation._internal();

  factory MyLocation() {
    return _instance;
  }

  MyLocation._internal();

  Geolocator geolocator = Geolocator();
  Position currentLocation;

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

  inAreaPresensi() {
    for (var zone in Application.remoteConfig.application.presensi.zone) {
      double distanceInMeters = Geolocator.distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          zone.latitude,
          zone.longitude);
      if (distanceInMeters < zone.radius) {
        UtilLogger.log('PRESENSI IN AREA', zone.name);
      }
      UtilLogger.log(
          'DISATANCE BEETWEEN AREA ${zone.name} METERS', distanceInMeters);
    }
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
}
