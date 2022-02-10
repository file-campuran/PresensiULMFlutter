import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class LocalNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  NotificationAppLaunchDetails notificationAppLaunchDetails;

  // singleton boilerplate
  static final LocalNotification _notificationServiceService =
      LocalNotification._internal();

  factory LocalNotification() {
    return _notificationServiceService;
  }
  // singleton boilerplate
  LocalNotification._internal();

  void init(BuildContext context) async {
    // WidgetsFlutterBinding.ensureInitialized();
    context = context;
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      UtilLogger.log('NOTIFICATION PAYLOAD', payload);
      if (payload != null) {
        onSelectNotification(payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future localNotifikasi(
      {String title, String body, String image, String payload}) async {
    var bigPictureStyleInformation;

    if (image != null) {
      var attachmentPicturePath =
          await _downloadAndSaveFile(image, 'attachment_img.jpg');

      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(attachmentPicturePath),
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: body,
        htmlFormatSummaryText: true,
      );
    }

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('presensi',
        'Presensi ULM', 'Presensi tenaga kependidikan dan tenaga pendidik',
        // sound: RawResourceAndroidNotificationSound('notification_sound'),
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation ?? null,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  BuildContext context;
  Future<void> onSelectNotification(String payload) async {
    // CURENTLY NOT WORK
    // Navigator.pushNamed(context, Routes.notification);
  }
}
