import 'package:absen_online/configs/environment.dart';

class RemoteConfigs {
  static final defaultConfig = {
    "environments": {
      "key": Environment.apiKey,
      "url": Environment.apiUrl,
      "id": Environment.apiId,
      "timeout": Environment.apiTimeout,
      "presensi_image_url": Environment.presensiImageUrl,
      "presensi_file_url": Environment.presensiFileUrl,
      "privacy_policy_url": Environment.privacyPolicy,
      "guide_url": Environment.guide,
      "nama_cs": Environment.namaCs,
      "no_cs": Environment.noCs
    },
    "presensi": {
      "zone": [
        {
          "name": "UNLAM BJB",
          "latitude": -3.4448526,
          "longitude": 114.8418003,
          "radius": 500
        },
        {
          "name": "UNLAM BJM",
          "latitude": -3.2975608,
          "longitude": 114.5846911,
          "radius": 800
        }
      ],
      "upload": {
        "max": "Maksimal berkas upload 213 KB",
        "mime": "File yang diperbolehkan hanya xls|jpg|png"
      },
      "detect_fake_gps": false,
      "detect_face": true,
      "detect_face_recognition": false,
      "show_face_information": true
    },
    "banner": [
      "https://simari.ulm.ac.id/assets/indihome.jpg",
      "https://simari.ulm.ac.id/assets/telkomsel.jpg",
      "https://simari.ulm.ac.id/assets/indosat.jpg"
    ],
    "update": {
      "release_version": "2.0.0",
      "min_version": 10,
      "ios_url":
          "https://play.google.com/store/apps/details?id=com.absen_online&hl=en&gl=US",
      "android_url":
          "https://play.google.com/store/apps/details?id=com.absen_online&hl=en&gl=US",
      "news": [
        "Penambahan deteksi wajah",
        "Perbaikan flash yang selalu menyala"
      ]
    }
  };
}
