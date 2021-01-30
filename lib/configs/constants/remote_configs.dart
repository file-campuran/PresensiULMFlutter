class RemoteConfigs {
  static const defaultConfig = {
    "application": {
      "release_version": "2.0.0",
      "min_version": 10,
      "upload": {
        "max": "Maksimal berkas upload 213 KB",
        "mime": "File yang diperbolehkan hanya xls|jpg|png"
      },
      "presensi": {
        "detect_fake_gps": false,
        "detect_face": true,
        "detect_face_recognition": false,
        "show_face_information": true,
      },
      "update": {
        "ios_url":
            "https://play.google.com/store/apps/details?id=com.absen_online&hl=en&gl=US",
        "android_url":
            "https://play.google.com/store/apps/details?id=com.absen_online&hl=en&gl=US",
        "news": [
          "Penambahan deteksi wajah",
          "Perbaikan flash yang selalu menyala"
        ]
      }
    },
    "banner": [
      "https://simari.ulm.ac.id/assets/indihome.jpg",
      "https://simari.ulm.ac.id/assets/telkomsel.jpg",
      "https://simari.ulm.ac.id/assets/indosat.jpg",
    ]
  };
}
