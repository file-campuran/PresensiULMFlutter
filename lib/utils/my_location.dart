import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MyLocation {
  ///Singleton factory
  static final MyLocation _instance = MyLocation._internal();

  factory MyLocation() {
    return _instance;
  }

  MyLocation._internal();

  Geolocator geolocator = Geolocator();

  StreamController<Position> _locationController = StreamController<Position>();

  Stream<Position> get locationStream => _locationController.stream;

  Future<Position> getLoacation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
