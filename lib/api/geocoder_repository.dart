import 'package:geocoding/geocoding.dart';

class GeocoderRepository {
  Future getAddress({double latitude, double longitude}) async {
    await Future.delayed(Duration(seconds: 1));

    if (latitude != null) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);

        if (placemarks != null && placemarks.isNotEmpty) {
          final Placemark pos = placemarks[0];
          String stringAddress =
              pos.thoroughfare.isEmpty ? '' : pos.thoroughfare + ', ';
          stringAddress = pos.locality.isEmpty ? '' : pos.locality + ', ';
          stringAddress = pos.subAdministrativeArea.isEmpty
              ? ''
              : pos.subAdministrativeArea;

          return stringAddress.isEmpty
              ? 'Lokasi tidak ditemukan'
              : stringAddress;
        } else {
          return 'Terjadi kesalahan mengambil lokasi';
        }
      } catch (e) {
        return 'Terjadi kesalahan mengambil lokasi';
      }
    }
  }

  Future getCity({double latitude, double longitude}) async {
    await Future.delayed(Duration(seconds: 1));

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
