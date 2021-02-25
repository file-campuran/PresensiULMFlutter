import 'package:absen_online/widgets/template/index.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:absen_online/app.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    UtilLogger.log('BLOC EVENT', event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    UtilLogger.log('BLOC TRANSITION', transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    UtilLogger.log(
        'BLOC CHANGE',
        'onChange ${cubit.runtimeType}'
            'From: ${change?.currentState} '
            'To: ${change.nextState}');
    super.onChange(cubit, change);
  }

  @override
  void onClose(Cubit cubit) {
    UtilLogger.log('BLOC CLOSE', '${cubit.runtimeType}');
    super.onClose(cubit);
  }

  @override
  void onCreate(Cubit cubit) {
    UtilLogger.log('BLOC CREATE', '${cubit.runtimeType}');
    super.onCreate(cubit);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    UtilLogger.log(
        'BLOC ERROR',
        'Error in : ${cubit.runtimeType}'
            'Error: $error'
            'StackTrace: $stackTrace');
    super.onError(cubit, error, stackTrace);
  }
}

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (!Environment.DEBUG || true) {
    runZonedGuarded(() {
      runApp(App());
    }, (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  } else {
    runApp(App());
  }
}
