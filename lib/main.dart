import 'package:bloc/bloc.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:absen_online/app.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AppDelegate extends BlocDelegate {
  ///Support Development
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    UtilLogger.log('BLOC EVENT', event);
  }

  ///Support Development
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    UtilLogger.log('BLOC TRANSITION', transition);
  }

  ///Support Development
  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    UtilLogger.log('BLOC ERROR', error);
  }
}

void main() async {
  BlocSupervisor.delegate = AppDelegate();
  // SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!Application.debug) {
    runZonedGuarded(() {
      runApp(App());
    }, (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  } else {
    runApp(App());
  }
}
