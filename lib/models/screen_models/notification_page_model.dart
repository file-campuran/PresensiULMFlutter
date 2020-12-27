import 'package:absen_online/models/model.dart';

class NotificationPageModel {
  final List<NotificationModel> notification;

  NotificationPageModel(
    this.notification,
  );

  factory NotificationPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable convertNotification = json['notification'] ?? [];

    final listCategory = convertNotification.map((item) {
      return NotificationModel.fromJson(item);
    }).toList();

    return NotificationPageModel(
      listCategory,
    );
  }
}
