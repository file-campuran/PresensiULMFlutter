import 'package:meta/meta.dart';

@immutable
abstract class ThemeState {}

class InitialThemeState extends ThemeState {}

class ThemeUpdating extends ThemeState {}

class ThemeUpdated extends ThemeState {}
