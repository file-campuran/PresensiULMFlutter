import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/models/model.dart';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotification {
  ///Singleton factory
  static final FirebaseNotification _instance =
      FirebaseNotification._internal();

  factory FirebaseNotification() {
    return _instance;
  }

  final FirebaseInAppMessaging _firebaseInAppMsg = FirebaseInAppMessaging();
  final _firebaseMessaging = FirebaseMessaging();

  // ignore: unused_element
  static Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
    dynamic notification;
    if (Platform.isAndroid) {
      notification =
          message['data'].isEmpty ? message['notification'] : message['data'];
    } else {
      notification = message['aps']['alert'];
    }
    UtilLogger.log("onBackground", '$message');

    Application.preferences = await SharedPreferences.getInstance();

    if (UtilPreferences.containsKey(Preferences.notification)) {
      if (!notification.isEmpty) {
        final notificationModel = NotificationModel.fromJson(
          {
            "id": new DateTime.now().millisecondsSinceEpoch,
            "isRead": 0,
            "title": notification['title'],
            "content": notification['body'],
            "payload": notification['payload'],
          },
        );

        Database db = await DBProvider.db.database;
        await db.insert(
          'Notification',
          notificationModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        LocalNotification().localNotifikasi(
            title: notification['title'], body: notification['body']);
      }
    }
  }

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  NotificationBloc _notificationBloc;

  ///Support Notification listen
  void initFirebaseNotification(BuildContext context) async {
    LocalNotification().init(context);
    UtilLogger.log('FIREBASE NOTIFICATION', 'Initialize Firebase Notification');
    // LocalNotification()
    //     .localNotifikasi(title: 'TESTED FROM SERVICE', body: 'SUCCESSED');
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);

    _firebaseInAppMsg.setAutomaticDataCollectionEnabled(true);

    if (Platform.isIOS) _iOSPermission();
    // await Future.delayed(Duration(seconds: 2));
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotif("onMessage", message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _showNotif("onLunch", message);
      },
      onResume: (Map<String, dynamic> message) async {
        _showNotif("onResume", message);
      },
      // onBackgroundMessage: Environment.DEBUG
      //     ? null
      //     : Platform.isIOS
      //         ? null
      //         : myBackgroundMessageHandler,
    );
    _firebaseMessaging.subscribeToTopic('general');
    _firebaseMessaging.subscribeToTopic(Application.user.role);

    Application.pushToken = await _firebaseMessaging.getToken();
    UtilLogger.log("MY TOKEN", Application.pushToken);
    PresensiRepository.setFirebaseToken();
  }

  void _showNotif(String log, Map<String, dynamic> message) {
    dynamic notification;
    if (Platform.isAndroid) {
      notification =
          message['data'].isEmpty ? message['notification'] : message['data'];
    } else {
      notification = message['aps']['alert'];
    }
    UtilLogger.log(log, message);

    if (UtilPreferences.containsKey(Preferences.notification)) {
      if (!notification.isEmpty) {
        // _notificationBloc.add(
        //     OnAddNotification(notification['title'], notification['body']));
        LocalNotification().localNotifikasi(
          title: notification['title'],
          body: notification['body'],
          payload: notification['payload'],
        );
      }
    }
  }

  FirebaseNotification._internal();
}
