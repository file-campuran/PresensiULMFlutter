import 'dart:developer' as developer;
import 'dart:convert';
import 'package:absen_online/configs/config.dart';

enum LogType { INFO, WARN, DANGER }
enum ColorsHeader { RED, GREEN, PURPLE, YELLOW, DEFAULT }

class UtilLogger {
  static const String TAG = "PRESENSI";

  static log([String tag = TAG, dynamic msg, LogType log = LogType.INFO]) {
    // if (Environment.DEBUG) {
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
    // }
  }

  static String convert(var data) {
    return JsonEncoder.withIndent('\t').convert(data);
  }

  static String color(String text, ColorsHeader colors) {
    switch (colors) {
      case ColorsHeader.RED:
        return ("\x1b[31m $text \x1b[0m");
        break;

      case ColorsHeader.PURPLE:
        return ("\x1b[35m $text \x1b[0m");
        break;

      case ColorsHeader.GREEN:
        return ("\x1b[32m $text \x1b[0m");
        break;

      case ColorsHeader.YELLOW:
        return ("\x1b[33m $text \x1b[0m");
        break;

      default:
        return (text);
    }
  }

  ///Singleton factory
  static final UtilLogger _instance = UtilLogger._internal();

  factory UtilLogger() {
    return _instance;
  }

  UtilLogger._internal();
}
