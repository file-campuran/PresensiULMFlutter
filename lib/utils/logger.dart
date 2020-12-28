import 'dart:developer' as developer;

import 'package:absen_online/configs/application.dart';

enum LogType { INFO, WARN, DANGER }

class UtilLogger {
  static const String TAG = "LISTAR";

  static log([String tag = TAG, dynamic msg, LogType log = LogType.INFO]) {
    if (Application.debug) {
      switch (log) {
        case LogType.INFO:
          developer.log('\x1b[32m $msg \x1b[0m', name: tag);
          break;

        case LogType.WARN:
          developer.log('\x1b[35m $msg \x1b[0m', name: tag);
          break;

        case LogType.DANGER:
          developer.log('\x1b[31m $msg \x1b[0m', name: tag);
          break;

        default:
          developer.log('\x1b[32m $msg \x1b[0m', name: tag);
      }
    }
  }

  ///Singleton factory
  static final UtilLogger _instance = UtilLogger._internal();

  factory UtilLogger() {
    return _instance;
  }

  UtilLogger._internal();
}
