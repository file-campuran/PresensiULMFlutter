import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';

enum DarkOption { dynamic, alwaysOn, alwaysOff }

class AppTheme {
  ///Optional Color
  static Color blueColor = Color.fromRGBO(93, 173, 226, 1);
  static Color pinkColor = Color.fromRGBO(165, 105, 189, 1);
  static Color greenColor = Color.fromRGBO(88, 214, 141, 1);
  static Color yellowColor = Color.fromRGBO(253, 198, 10, 1);
  static Color kashmirColor = Color.fromRGBO(93, 109, 126, 1);

  ///Default font
  static String currentFont = "ProductSans";

  ///List Font support
  static List<String> fontSupport = [
    "ProductSans",
    "Raleway",
    "Roboto",
    "Merriweather",
    "SourceSansPro",
    "Intro",
    "Lato",
  ];

  ///Default Theme
  static ThemeModel currentTheme = ThemeModel.fromJson({
    "name": "default",
    "color": Color(0xfff6bb41),
    "light": "pastelOrangeLight",
    "dark": "pastelOrangeDark",
  });

  ///List Theme Support in Application
  static List themeSupport = [
    {
      "name": "default",
      "color": Color(0xfff6bb41),
      "light": "pastelOrangeLight",
      "dark": "pastelOrangeDark",
    },
    {
      "name": "brown",
      "color": Color(0xffa0877e),
      "light": "brownLight",
      "dark": "brownDark",
    },
    {
      "name": "pink",
      "color": Color(0xffe0a6c1),
      "light": "pinkLight",
      "dark": "pinkDark",
    },
    {
      "name": "orange",
      "color": Color(0xffe5634d),
      "light": "primaryLight",
      "dark": "primaryDark",
    },
    {
      "name": "green",
      "color": Color(0xff93b7b0),
      "light": "greenLight",
      "dark": "greenDark",
    },
    {
      "name": "yellow",
      "color": Color(0xfff6bb41),
      "light": "pastelOrangeLight",
      "dark": "pastelOrangeDark",
    },
  ].map((item) => ThemeModel.fromJson(item)).toList();

  ///Dark Theme option
  static DarkOption darkThemeOption = DarkOption.alwaysOff;

  static ThemeData lightTheme = CollectionTheme.getCollectionTheme(
    theme: currentTheme.lightTheme,
  );

  static ThemeData darkTheme = CollectionTheme.getCollectionTheme(
    theme: currentTheme.darkTheme,
  );

  ///Singleton factory
  static final AppTheme _instance = AppTheme._internal();

  factory AppTheme() {
    return _instance;
  }

  AppTheme._internal();
}
