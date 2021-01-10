import 'package:flutter/cupertino.dart';

abstract class LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;

  ChangeLanguage(this.locale);
}
