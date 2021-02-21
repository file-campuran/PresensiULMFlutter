import 'package:flutter/material.dart';
import 'package:absen_online/screens/screen.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MainNavigation extends StatefulWidget {
  MainNavigation({Key key}) : super(key: key);

  @override
  _MainNavigationState createState() {
    return _MainNavigationState();
  }
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    FirebaseNotification().initFirebaseNotification(context);
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    UtilLogger.log('CONECTIVITY', result);
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        // Navigator.of(context).pop();
        break;
      case ConnectivityResult.none:
        appMyInfoDialog(
          context: context,
          message:
              'Coba periksa apakah smartphone anda sudah terhubung ke jaringan seluler atau Wi-Fi',
          image: Images.Working,
          title: 'Yah, sepertinya anda tidak terhubung ke sambungan internet',
        );
        break;
      default:
        setState(() => connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
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

// BODY SCAFFOLD ANIMATED ON CHANGE PAGE
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
