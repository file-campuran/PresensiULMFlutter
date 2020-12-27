import 'package:flutter/material.dart';

class AppLanguage {
  ///Default Language
  static Locale defaultLanguage = Locale("en");

  ///List Language support in Application
  static List<Locale> supportLanguage = [
    Locale("en"),
    Locale("vi"),
    Locale("ar"),
    Locale("da"),
    Locale("de"),
    Locale("el"),
    Locale("fr"),
    Locale("he"),
    Locale("id"),
    Locale("ja"),
    Locale("ko"),
    Locale("lo"),
    Locale("nl"),
    Locale("zh"),
    Locale("fa"),
    Locale("km"),
  ];

  ///Singleton factory
  static final AppLanguage _instance = AppLanguage._internal();

  factory AppLanguage() {
    return _instance;
  }

  AppLanguage._internal();
}
