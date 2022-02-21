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
          List<String> stringAddress = [];

          // Jalan A. Yani
          if (pos.thoroughfare.isNotEmpty) stringAddress.add(pos.thoroughfare);

          // Kecamatan Banjarbaru Selatan
          if (pos.locality.isNotEmpty) stringAddress.add(pos.locality);

          // Kota Banjarbaru
          if (pos.subAdministrativeArea.isNotEmpty)
            stringAddress.add(pos.subAdministrativeArea);

          // Kalimantan Selatan
          if (pos.administrativeArea.isNotEmpty)
            stringAddress.add(pos.administrativeArea);

          // Indonesia
          if (pos.country.isNotEmpty) stringAddress.add(pos.country);

          // Combine Area
          return stringAddress.isEmpty ? '-' : stringAddress.join(', ');
        } else {
          return 'Terjadi kesalahan mengambil lokasi';
        }
      } catch (e) {
        return e.toString();
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
