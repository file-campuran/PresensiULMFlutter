import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/screens/screen.dart';
import 'package:absen_online/utils/logger.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/models/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//   LocalNotification().localNotifikasi(title: 'TITLE', body: 'BODY');
//   print('on background $message');
// }
// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   // final notification = message['data'];
//   // AppNotification()
//   //     .addNotification(notification['title'], notification['body']);
//   // LocalNotification().localNotifikasi(
//   //     title: notification['title'], body: notification['body']);
//   final pref = await SharedPreferences.getInstance();

//   pref.setString('tes', 'tes');
//   UtilLogger.log("onBackground", '$message');
// }

class MainNavigation extends StatefulWidget {
  MainNavigation({Key key}) : super(key: key);

  @override
  _MainNavigationState createState() {
    return _MainNavigationState();
  }
}

class _MainNavigationState extends State<MainNavigation> {
  final _fcm = FirebaseMessaging();
  int _selectedIndex = 0;
  NotificationBloc _notificationBloc;
  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    _fcmHandle();
    LocalNotification().init();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        return Fluttertoast.showToast(
            msg: 'Online',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        break;
      case ConnectivityResult.none:
        UtilLogger.log('NETWORK', result.toString(), LogType.INFO);
        return Fluttertoast.showToast(
            msg: "Check your internet connection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        break;
      default:
        UtilLogger.log(
            'NETWORK', 'Failed to get connectivity.', LogType.DANGER);
        break;
    }
  }

  static Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
    final notification = message['data'];
    final pref = await SharedPreferences.getInstance();
    final notificationPref = pref.getString(Preferences.notification);
    NotificationPageModel _notificationPage;

    if (notificationPref != null && notificationPref != '') {
      _notificationPage = notificationPageModelFromJson(notificationPref);
    } else {
      _notificationPage = NotificationPageModel.fromJson({'notification': []});
    }

    _notificationPage.notification.add(NotificationModel.fromJson({
      "id": 6,
      "isRead": false,
      "title": notification['title'],
      "content": notification['body'],
    }));

    pref.setString(Preferences.notification, _notificationPage.toString());

    // AppNotification()
    //     .addNotification(notification['title'], notification['body']);
    LocalNotification().localNotifikasi(
        title: notification['title'], body: notification['body']);
    UtilLogger.log("onBackground", '$message');
  }

  void iOSPermission() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  ///Support Notification listen
  void _fcmHandle() async {
    if (Platform.isIOS) iOSPermission();
    // await Future.delayed(Duration(seconds: 2));
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotif("onMessage", message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _showNotif("onLunch", message);
      },
      onResume: (Map<String, dynamic> message) async {
        _showNotif("onResumr", message);
      },
      // onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    );
    Application.pushToken = await _fcm.getToken();
    UtilLogger.log("MY TOKEN", Application.pushToken);
    PresensiRepository.setFirebaseToken();

    // RemoteConfig config = await FirebaseRemoteConfig.setupRemoteConfig();
    // Application.remoteConfig = configModelFromJson(config.getString('config'));
    // UtilLogger.log('REMOTE CONFIG', Application.remoteConfig.toJson());
  }

  void _showNotif(String log, Map<String, dynamic> message) {
    final notification = message['data'];
    UtilLogger.log(log, '$notification');
    _notificationBloc
        .add(OnAddNotification(notification['title'], notification['body']));
    LocalNotification().localNotifikasi(
        title: notification['title'], body: notification['body']);
  }

  ///On change tab bottom menu
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///List bottom menu
  List<BottomNavigationBarItem> _bottomBarItem(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('home')),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.face_sharp),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('presence')),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('history')),
        ),
      ),
      // BottomNavigationBarItem(
      //   icon: new Stack(children: <Widget>[
      //     new Icon(Icons.alarm),
      //     new Positioned(
      //         // draw a red marble
      //         top: 0.0,
      //         right: 0.0,
      //         child: BlocBuilder<NotificationBloc, NotificationState>(
      //           builder: (context, state) {
      //             if (state is NotificationData) {
      //               if (state.data.count != 0) {
      //                 return Stack(
      //                   alignment: Alignment.center,
      //                   children: [
      //                     Container(
      //                       width: 10,
      //                       height: 10,
      //                       decoration: BoxDecoration(
      //                         shape: BoxShape.circle,
      //                         color: Colors.redAccent,
      //                       ),
      //                     ),
      //                     Text(
      //                       state.data.count.toString(),
      //                       style: TextStyle(
      //                         color: Colors.white,
      //                         fontSize: 8,
      //                       ),
      //                     ),
      //                   ],
      //                 );
      //               }
      //               return Container();
      //             }
      //             return Container();
      //           },
      //         ))
      //   ]),
      //   title: Padding(
      //     padding: EdgeInsets.only(top: 3),
      //     child: Text(Translate.of(context).translate('notification')),
      //   ),
      // ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('account')),
        ),
      ),
    ];
  }

  final List<Widget> _widgetOptions = [
    Beranda(),
    Presensi(),
    Riwayat(),
    // NotificationList(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    // LocalNotification().localNotifikasi(title: "TETEL", body: "BODE");
    return Scaffold(
      body: WillPopScope(
        child: _widgetOptions.elementAt(_selectedIndex),
        onWillPop: onWillPop,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomBarItem(context),
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  DateTime currentBackPressTime;

  /// Function double tap back when close from apps
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: Translate.of(context).translate('ask_quit'));
      return Future.value(false);
    }
    return Future.value(true);
  }
}
