import 'package:flutter/material.dart';

class Green {
  ///Singleton factory
  static final Green _instance = Green._internal();

  factory Green() {
    return _instance;
  }

  Green._internal();

  static ThemeData getTheme({@required String font, bool isLight = false}) {
    switch (isLight) {
      case true:
        return ThemeData(
          primarySwatch: MaterialColor(4287870896, {
            50: Color(0xfff0f5f4),
            100: Color(0xffe0ebe9),
            200: Color(0xffc2d6d2),
            300: Color(0xffa3c2bc),
            400: Color(0xff85ada5),
            500: Color(0xff66998f),
            600: Color(0xff527a72),
            700: Color(0xff3d5c56),
            800: Color(0xff293d39),
            900: Color(0xff141f1d)
          }),
          fontFamily: font,
          brightness: Brightness.light,
          primaryColor: Color(0xff27AE60),
          primaryColorBrightness: Brightness.dark,
          primaryColorLight: Color(0xffe0ebe9),
          primaryColorDark: Color(0xff3d5c56),
          accentColor: Color(0xff27AE60),
          accentColorBrightness: Brightness.dark,
          canvasColor: Color(0xfffafafa),
          scaffoldBackgroundColor: Colors.white,
          bottomAppBarColor: Color(0xffffffff),
          cardColor: Color(0xffffffff),
          dividerColor: Color(0x1f000000),
          highlightColor: Color(0x66bcbcbc),
          splashColor: Color(0x66c8c8c8),
          selectedRowColor: Color(0xfff5f5f5),
          unselectedWidgetColor: Color(0x8a000000),
          disabledColor: Color(0x61000000),
          buttonColor: Color(0xff27AE60),
          toggleableActiveColor: Color(0xff527a72),
          secondaryHeaderColor: Color(0xfff0f5f4),
          textSelectionColor: Color(0xffc2d6d2),
          cursorColor: Color(0xff4285f4),
          textSelectionHandleColor: Color(0xffa3c2bc),
          backgroundColor: Color(0xffc2d6d2),
          dialogBackgroundColor: Color(0xffffffff),
          indicatorColor: Color(0xff27AE60),
          hintColor: Color(0x8a000000),
          errorColor: Color(0xffd32f2f),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.accent,
            minWidth: 88,
            height: 48,
            padding: EdgeInsets.only(left: 16, right: 16),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff000000),
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            buttonColor: Color(0xff27AE60),
            disabledColor: Color(0x61000000),
            highlightColor: Color(0x29000000),
            splashColor: Color(0x1f000000),
            focusColor: Color(0x1f000000),
            hoverColor: Color(0x0a000000),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 15,
              right: 15,
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Color(0x1f000000),
            brightness: Brightness.light,
            deleteIconColor: Color(0xde000000),
            disabledColor: Color(0x0c000000),
            labelPadding: EdgeInsets.only(left: 8, right: 8),
            labelStyle: TextStyle(
              fontSize: 12,
              fontFamily: font,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
            secondaryLabelStyle: TextStyle(
              fontSize: 12,
              fontFamily: font,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            secondarySelectedColor: Color(0x3d93b7b0),
            selectedColor: Color(0x3d93b7b0),
            shape: StadiumBorder(
              side: BorderSide(
                color: Color(0xff000000),
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      default:
        return ThemeData(
          primarySwatch: MaterialColor(4280361249, {
            50: Color(0xfff2f2f2),
            100: Color(0xffe6e6e6),
            200: Color(0xffcccccc),
            300: Color(0xffb3b3b3),
            400: Color(0xff999999),
            500: Color(0xff808080),
            600: Color(0xff666666),
            700: Color(0xff4d4d4d),
            800: Color(0xff333333),
            900: Color(0xff191919)
          }),
          fontFamily: font,
          brightness: Brightness.dark,
          primaryColor: Color(0xff27AE60),
          primaryColorBrightness: Brightness.dark,
          primaryColorLight: Color(0xff9e9e9e),
          primaryColorDark: Color(0xff000000),
          accentColor: Color(0xff27AE60),
          accentColorBrightness: Brightness.light,
          canvasColor: Colors.grey[900],
          scaffoldBackgroundColor: Color(0xff303030),
          bottomAppBarColor: Color(0xff424242),
          cardColor: Color(0xff424242),
          dividerColor: Color(0x1fffffff),
          highlightColor: Color(0x40cccccc),
          splashColor: Color(0x40cccccc),
          selectedRowColor: Color(0xfff5f5f5),
          unselectedWidgetColor: Color(0xb3ffffff),
          disabledColor: Color(0x62ffffff),
          buttonColor: Color(0xff27AE60),
          toggleableActiveColor: Color(0xff27AE60),
          secondaryHeaderColor: Color(0xff616161),
          textSelectionColor: Color(0xff3d5c56),
          cursorColor: Color(0xff4285f4),
          textSelectionHandleColor: Color(0xff3d5c56),
          backgroundColor: Color(0xff616161),
          dialogBackgroundColor: Color(0xff424242),
          indicatorColor: Color(0xff27AE60),
          hintColor: Color(0x80ffffff),
          errorColor: Color(0xffd32f2f),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Colors.grey[900],
          ),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.accent,
            minWidth: 88,
            height: 48,
            padding: EdgeInsets.only(left: 16, right: 16),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff000000),
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            buttonColor: Color(0xff27AE60),
            disabledColor: Color(0x61ffffff),
            highlightColor: Color(0x29ffffff),
            splashColor: Color(0x1fffffff),
            focusColor: Color(0x1fffffff),
            hoverColor: Color(0x0affffff),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 15,
              right: 15,
            ),
          ),
          sliderTheme: SliderThemeData.fromPrimaryColors(
            primaryColor: Color(0xff27AE60),
            primaryColorLight: Color(0xffe0ebe9),
            primaryColorDark: Color(0xff27AE60),
            valueIndicatorTextStyle: TextStyle(
              color: Color(0xffffffff),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Color(0x1fffffff),
            brightness: Brightness.dark,
            deleteIconColor: Color(0xdeffffff),
            disabledColor: Color(0x0cffffff),
            labelPadding: EdgeInsets.only(left: 8, right: 8),
            labelStyle: TextStyle(
              fontSize: 12,
              fontFamily: font,
              color: Color(0xb3ffffff),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
            secondaryLabelStyle: TextStyle(
              fontSize: 12,
              fontFamily: font,
              color: Color(0xb3ffffff),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            secondarySelectedColor: Color(0x3d212121),
            selectedColor: Color(0x3dffffff),
            shape: StadiumBorder(
              side: BorderSide(
                color: Color(0xff000000),
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
    }
  }
}
