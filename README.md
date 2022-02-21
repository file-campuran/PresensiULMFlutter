<p align="center">
  <img src="https://github.com/Killers007/PresensiULMFlutter/blob/master/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" />
</p>

# Presensi ULM Mobile App (Flutter)

[![Codemagic build status](https://api.codemagic.io/apps/5f3bab9add10563324d17fbd/5f3bab9add10563324d17fbc/status_badge.svg)](https://codemagic.io/app/607f9a68f83ae43e58ed587c/build/620de6a2b90d559fa87599e7)
</br></br>

<a href='https://apps.apple.com/id/app/presensi-ulm/id1531042438' target='_blank'><img src='https://user-images.githubusercontent.com/26994065/96281189-32e8dc80-1003-11eb-94af-b0cfb12da92d.png' width='150px'></a> <a href='https://play.google.com/store/apps/details?id=com.absen_online&hl=en&gl=US' target='_blank'><img src='https://user-images.githubusercontent.com/26994065/96281556-b0145180-1003-11eb-812b-c513928b90df.png' width='150px'></a>

## Index

- [Presensi ULM Mobile App (Flutter)](#presensi-ulm-mobile-app-flutter)
  - [Index](#index)
      - [Firebase SDK](#firebase-sdk)
  - [Windows Android Setup](#windows-android-setup)
  - [iOS Setup](#ios-setup)
    - [Manual Upload DSYM](#manual-upload-dsym)

  
#### Firebase SDK

1. [Buat project baru pada console firebase](https://firebase.google.com/docs/flutter/setup#create_firebase_project)

2. [Konfigurasi aplikasi android untuk menggunakan Firebase](https://firebase.google.com/docs/flutter/setup#configure_an_android_app)

#### Firebase Remote Config <KEY, VALUE>
![Screenshot 2022-02-21 111239](https://user-images.githubusercontent.com/28392136/154883249-73edb5b7-a026-453c-966b-9452b3fcb8de.png)

``` json
{
  "update": {
    "release_version": "2.0.0",
    "min_version": 10,
    "ios_url": "https://play.google.com/store/apps/details?id=com.absen_online&hl=en&gl=US",
    "android_url": "https://play.google.com/store/apps/details?id=com.absen_online&hl=en&gl=US",
    "news": [
      "Penambahan deteksi wajah",
      "Perbaikan flash yang selalu menyala"
    ]
  },
  "environments": {
    "key": "605dafe39ee0780e8cf2c829434eea99",
    "url": "https://apiv2.ulm.ac.id/api",
    "id": "PresensiULM",
    "timeout": 20,
    "presensi_image_url": "https://apiv2.ulm.ac.id/api/presensi/file/foto",
    "presensi_file_url": "https://apiv2.ulm.ac.id/api/presensi/file/berkas",
    "privacy_policy_url": "https://simari.ulm.ac.id/privacy_policy_presensi.html",
    "guide_url": "https://simari.ulm.ac.id",
    "no_cs": "+6282149091899"
  },
  "presensi": {
    "zone": [],
    "upload": {
      "max": "Maksimal berkas upload 3 MB",
      "mime": "File yang diperbolehkan hanya jpg|jpeg|png|pdf|docx|doc|xls|xlsx|ppt|pptx|csv"
    },
    "detect_fake_gps": false,
    "detect_face": true,
    "detect_face_recognition": false,
    "show_face_information": true
  }
}

```

## Windows Android Setup
``` bash
# install dependencies
$ flutter pub get
# build apk
$ flutter build apk --split-per-abi
#  ( Jika stuck di splash screen )
$ flutter build apk --no-shrink --split-per-abi
```

## iOS Setup
``` bash
# Set Path Flutter
$ export PATH="/Users/ptik/Downloads/flutter/bin":$PATH
# Build IOS (Generate Codesigning)
$ flutter buiild ios
# Install Pods jika ada pembaharuan
$ Pods install

Open Runner.xcodeworkspace

#FIX IOS 15 XCODE
Other Code Signing Flags : --generate-entitlement-der

#UPLOAD DYSM
Xcode -> Organize -> Show In Finder -> Explore archive -> Archive dsyms.zip -> Copy to ios folder https://i.stack.imgur.com/qIaU3.gif

# OR
cek di d derived data Xcode -> Preferences -> Location -> Derived Data -> Runner XXX -> Build -> Products (Cari dSYM file)

# OR
run command di path /ios
find /Users/ptik/Library/Developer/Xcode/DerivedData/Runner*/Build/Products/*/Runner* -name "*.dSYM" | xargs -I \{\} Pods/FirebaseCrashlytics/upload-symbols -gsp GoogleService-Info.plist -p ios \{\}

iMac-UPP:ios ptik$ Pods/FirebaseCrashlytics/upload-symbols -gsp GoogleService-Info.plist -p ios /dSYMs.zip


#FIX IOS 15 XCODE
Other Code Signing Flags : --generate-entitlement-der

```


### Manual Upload DSYM
Upload dSYM untuk keperluan Firebase Crashltic
![alt](https://i.stack.imgur.com/qIaU3.gif)


For detailed explanation on how things work, check out [Flutter docs](https://flutter.dev/docs).

