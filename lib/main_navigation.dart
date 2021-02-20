import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/screens/screen.dart';
import 'package:absen_online/utils/services/logger.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/models/model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainNavigation extends StatefulWidget {
  MainNavigation({Key key}) : super(key: key);

  @override
  _MainNavigationState createState() {
    return _MainNavigationState();
  }
}

class _MainNavigationState extends State<MainNavigation> {
  final FirebaseInAppMessaging firebaseInAppMsg = FirebaseInAppMessaging();
  final _fcm = FirebaseMessaging();
  int _selectedIndex = 0;
  NotificationBloc _notificationBloc;
  // ignore: unused_field
  MessageCubit _messageCubit;

  @override
  void initState() {
    _fcmHandle();

    LocalNotification().init();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _messageCubit = BlocProvider.of<MessageCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: unused_element
  static Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
    final notification =
        message['data'].isEmpty ? message['notification'] : message['data'];
    UtilLogger.log("onBackground", '$message');

    Application.preferences = await SharedPreferences.getInstance();

    if (UtilPreferences.containsKey(Preferences.notification)) {
      final notificationModel = NotificationModel.fromJson(
        {
          "id": new DateTime.now().millisecondsSinceEpoch,
          "isRead": 0,
          "title": notification['title'],
          "content": notification['body'],
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

  void iOSPermission() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  ///Support Notification listen
  void _fcmHandle() async {
    firebaseInAppMsg.setAutomaticDataCollectionEnabled(true);

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
        _showNotif("onResume", message);
      },
      onBackgroundMessage: Environment.DEBUG
          ? null
          : Platform.isIOS
              ? null
              : myBackgroundMessageHandler,
    );
    _fcm.subscribeToTopic('general');
    _fcm.subscribeToTopic(Application.user.role);

    Application.pushToken = await _fcm.getToken();
    UtilLogger.log("MY TOKEN", Application.pushToken);
    PresensiRepository.setFirebaseToken();
  }

  void _showNotif(String log, Map<String, dynamic> message) {
    final notification =
        message['data'].isEmpty ? message['notification'] : message['data'];
    UtilLogger.log(log, '$message');

    if (UtilPreferences.containsKey(Preferences.notification)) {
      _notificationBloc
          .add(OnAddNotification(notification['title'], notification['body']));
      LocalNotification().localNotifikasi(
          title: notification['title'], body: notification['body']);
    }
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
        icon: Icon(_selectedIndex == 0 ? EvaIcons.grid : EvaIcons.gridOutline),
        label: Translate.of(context).translate('home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(
            _selectedIndex == 1 ? EvaIcons.layers : EvaIcons.layersOutline),
        label: Translate.of(context).translate('history'),
      ),
      BottomNavigationBarItem(
        icon: Icon(
            _selectedIndex == 2 ? EvaIcons.bookOpen : EvaIcons.bookOpenOutline),
        label: Translate.of(context).translate('presence'),
      ),
      BottomNavigationBarItem(
        label: Translate.of(context).translate('message'),
        icon: new Stack(alignment: Alignment.center, children: <Widget>[
          new Icon(_selectedIndex == 3
              ? EvaIcons.messageCircle
              : EvaIcons.messageCircleOutline),
          BlocBuilder<MessageCubit, MessageState>(
            builder: (context, state) {
              if (state is MessageData) {
                if (state.count != 0) {
                  return new Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                        ),
                        Container(
                          child: Text(
                            state.count.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }
              return Container();
            },
          ),
        ]),
      ),
      BottomNavigationBarItem(
        icon: Icon(_selectedIndex == 4
            ? Icons.account_circle
            : Icons.account_circle_outlined),
        label: Translate.of(context).translate('account'),
      ),
    ];
  }

  final List<Widget> _widgetOptions = [
    Beranda(),
    Riwayat(),
    Presensi(),
    Message(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    Adapt.initContext(context);

    // LocalNotification().localNotifikasi(title: "TETEL", body: "BODE");
    return Scaffold(
      // body: WillPopScope(
      //   child: AnimatedSwitcher(
      //     duration: const Duration(milliseconds: 500),
      //     transitionBuilder: (Widget child, Animation<double> animation) {
      //       return FadeTransition(child: child, opacity: animation);
      //     },
      //     child: _widgetOptions.elementAt(_selectedIndex),
      //   ),
      //   onWillPop: onWillPop,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _onItemTapped(2);
      //     // setState(() {});
      //   },
      //   child: Icon(_selectedIndex == 1
      //       ? Icons.check_circle_outline
      //       : Icons.check_circle_outline_sharp),
      //   elevation: 4.0,
      // ),
      body: _widgetOptions.elementAt(_selectedIndex),
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
