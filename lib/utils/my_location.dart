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
      // Geolocator.checkPermission();
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

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
