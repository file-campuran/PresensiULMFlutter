import 'package:geolocator/geolocator.dart';

class GeocoderRepository {
  ///Singleton factory
  static final GeocoderRepository _instance = GeocoderRepository._internal();

  factory GeocoderRepository() {
    return _instance;
  }

  GeocoderRepository._internal();

  Future getAddress({double latitude, double longitude}) async {
    await Future.delayed(Duration(seconds: 1));

    if (latitude != null) {
      List<Placemark> placemarks =
          await Geolocator().placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        final stringAddress = pos.thoroughfare +
            ', ' +
            pos.locality +
            ', ' +
            pos.subAdministrativeArea;

        return stringAddress;
      } else {
        throw Exception('Dictionary.somethingWrong');
      }
    }
  }

  Future getCity({double latitude, double longitude}) async {
    await Future.delayed(Duration(seconds: 1));

    if (latitude != null) {
      List<Placemark> placemarks =
          await Geolocator().placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];

        return pos.subAdministrativeArea;
      } else {
        throw Exception('Dictionary.somethingWrong');
      }
    }
  }
}
