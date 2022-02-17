
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

