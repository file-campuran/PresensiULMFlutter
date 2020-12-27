import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/application.dart';
import 'package:absen_online/screens/screen.dart';
import 'package:absen_online/utils/logger.dart';
import 'package:absen_online/utils/utils.dart';

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
        icon: Icon(Icons.bookmark),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('wish_list')),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('message')),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('notification')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthenticationState>(
        builder: (context, auth) {
          return IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              Home(),
              WishList(),
              MessageList(),
              NotificationList(),
              auth is AuthenticationSuccess ? Profile() : SignIn()
            ],
          );
        },
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
}
