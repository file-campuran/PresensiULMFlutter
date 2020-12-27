import 'package:meta/meta.dart';

@immutable
abstract class ApplicationEvent {}

///Event notification setup application
class SetupApplication extends ApplicationEvent {}

///Event notification completed preview intro
class OnCompletedIntro extends ApplicationEvent {}
