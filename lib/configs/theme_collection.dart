import 'package:flutter/material.dart';
import 'theme_data/theme_data.dart';

class CollectionTheme {
  ///Get collection theme
  ///
  /// primaryLight/primaryDark/brownLight/brownDark/pinkLight/pinkDark
  static ThemeData getCollectionTheme(
      {String theme = "primaryLight", String font = "Raleway"}) {
    switch (theme) {
      case "primaryLight":
        return Primary.getTheme(font: font, isLight: true);

      case "primaryDark":
        return Primary.getTheme(font: font);

      case "brownLight":
        return Brown.getTheme(font: font, isLight: true);

      case "brownDark":
        return Brown.getTheme(font: font);

      case "pinkLight":
        return Pink.getTheme(font: font, isLight: true);

      case "pinkDark":
        return Pink.getTheme(font: font);

      case "pastelOrangeLight":
        return PastelOrange.getTheme(font: font, isLight: true);

      case "pastelOrangeDark":
        return PastelOrange.getTheme(font: font);

      case "ulmLight":
        return Ulm.getTheme(font: font, isLight: true);

      case "ulmDark":
        return Ulm.getTheme(font: font);

      case "greenLight":
        return Green.getTheme(font: font, isLight: true);

      case "greenDark":
        return Green.getTheme(font: font);

      default:
        return Ulm.getTheme(font: font, isLight: true);
    }
  }

  ///Singleton factory
  static final CollectionTheme _instance = CollectionTheme._internal();

  factory CollectionTheme() {
    return _instance;
  }

  CollectionTheme._internal();
}
