import 'package:geocoding/geocoding.dart';

class GeocoderRepository {
  Future getAddress({double latitude, double longitude}) async {
    // await Future.delayed(Duration(seconds: 1));

    if (latitude != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

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
    // await Future.delayed(Duration(seconds: 1));

    if (latitude != null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];

        return pos.subAdministrativeArea;
      } else {
        throw Exception('Dictionary.somethingWrong');
      }
    }
  }
}
