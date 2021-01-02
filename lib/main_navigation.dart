import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/application.dart';
import 'package:absen_online/screens/screen.dart';
import 'package:absen_online/utils/logger.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

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

  @override
  void initState() {
    _fcmHandle();
    super.initState();
  }

  ///Support Notification listen
  void _fcmHandle() async {
    await Future.delayed(Duration(seconds: 2));
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        final notification = message['aps']['alert'];
        UtilLogger.log("onMessage", '$notification');
        _showNotification(notification['title'], notification['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        final notification = message['aps']['alert'];
        _showNotification(notification['title'], notification['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['aps']['alert'];
        _showNotification(notification['title'], notification['body']);
        UtilLogger.log("onResume", 'onMessage $message');
      },
    );
    Application.pushToken = await _fcm.getToken();
    UtilLogger.log("MY TOKEN", Application.pushToken);

    // RemoteConfig config = await FirebaseRemoteConfig.setupRemoteConfig();
    // Application.remoteConfig = configModelFromJson(config.getString('config'));
    // UtilLogger.log('REMOTE CONFIG', Application.remoteConfig.toJson());
  }

  ///On change tab bottom menu
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ///Show notification received
  Future<void> _showNotification(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message, style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(Translate.of(context).translate('close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
