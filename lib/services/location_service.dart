// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocationService {
//   static Future<void> sendCurrentLocation(BuildContext context) async {
//     var permissionService =
//         Platform.isIOS ? Permission.locationWhenInUse : Permission.location;

//     // if (await permissionService.status.isGranted) {
//     //   await actionSendLocation();
//     // } else {
//     showModalBottomSheet(
//         context: context,
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(8.0),
//             topRight: Radius.circular(8.0),
//           ),
//         ),
//         isDismissible: false,
//         builder: (context) {
//           return SingleChildScrollView(
//             child: Container(
//               margin: EdgeInsets.all(10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Image.asset(
//                     'permission_location.png',
//                     fit: BoxFit.fitWidth,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Dictionary.permissionLocationGeneral',
//                     textAlign: TextAlign.center,
//                     style:
//                         TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Dictionary.permissionLocationAgreement',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 24.0),
//                   Row(
//                     children: <Widget>[
//                       // Expanded(
//                       //     child: RoundedButton(
//                       //         title: Dictionary.later,
//                       //         textStyle: TextStyle(
//                       //             fontFamily: FontsFamily.lato,
//                       //             fontSize: 12.0,
//                       //             fontWeight: FontWeight.bold,
//                       //             color: ColorBase.green),
//                       //         color: Colors.white,
//                       //         borderSide: BorderSide(color: ColorBase.green),
//                       //         elevation: 0.0,
//                       //         onPressed: () {
//                       //           AnalyticsHelper.setLogEvent(
//                       //               Analytics.permissionDismissLocation);
//                       //           Navigator.of(context).pop();
//                       //         })),
//                       // SizedBox(width: 10),
//                       // Expanded(
//                       //     child: RoundedButton(
//                       //         title: Dictionary.agree,
//                       //         textStyle: TextStyle(
//                       //             fontFamily: FontsFamily.lato,
//                       //             fontSize: 12.0,
//                       //             fontWeight: FontWeight.bold,
//                       //             color: Colors.white),
//                       //         color: ColorBase.green,
//                       //         elevation: 0.0,
//                       //         onPressed: () async {
//                       //           Navigator.of(context).pop();
//                       //           if (await permissionService
//                       //               .status.isPermanentlyDenied) {
//                       //             Platform.isAndroid
//                       //                 ? await AppSettings.openAppSettings()
//                       //                 : await AppSettings
//                       //                     .openLocationSettings();
//                       //           } else {
//                       //             permissionService.request().then((status) {
//                       //               _onStatusRequested(context, status);
//                       //             });
//                       //           }
//                       //         }))
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//   // }

//   static Future<void> actionSendLocation() async {
//     var permissionService =
//         Platform.isIOS ? Permission.locationWhenInUse : Permission.location;

//     if (await permissionService.isGranted) {
//       // int oldTime =
//       //     await LocationSharedPreference.getLastLocationRecordingTime();

//       // if (oldTime == null) {
//       //   oldTime =
//       //       DateTime.now().add(Duration(minutes: -6)).millisecondsSinceEpoch;
//       //   await LocationSharedPreference.setLastLocationRecordingTime(oldTime);
//       // }

//       // int minutes = DateTime.now()
//       //     .difference(DateTime.fromMillisecondsSinceEpoch(oldTime))
//       //     .inMinutes;
//       Position position = await Geolocator()
//           .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//       if (position != null && position.latitude != null) {
//         // if (minutes >= 5) {
//         //   int currentMillis = DateTime.now().millisecondsSinceEpoch;

//         // LocationModel data = LocationModel(
//         //     id: currentMillis.toString(),
//         //     latitude: position.latitude,
//         //     longitude: position.longitude,
//         //     timestamp: currentMillis);

//         // await LocationsRepository().saveLocationToFirestore(data);
//         print(position);

//         // This call after all process done (Moved to LocationsRepository)
//         /*await LocationSharedPreference.setLastLocationRecordingTime(
//             currentMillis);*/
//       }
//     }
//   }
// }

// //   static Future<void> _onStatusRequested(
// //       BuildContext context, PermissionStatus statuses) async {
// //     if (statuses.isGranted) {
// //       await actionSendLocation();
// //       // AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
// //     } else {
// //       // AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
// //     }
// //   }
// // }
