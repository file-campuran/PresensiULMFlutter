import 'package:meta/meta.dart';
import 'package:absen_online/models/model.dart';

@immutable
abstract class NotificationState {}

class InitialNotificationState extends NotificationState {}

class NotificationData extends NotificationState {
  final NotificationPageModel data;

  NotificationData(this.data);
}

class NotificationCount extends NotificationState {
  final int count;

  NotificationCount(this.count);
}
