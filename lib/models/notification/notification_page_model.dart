import 'model_notification.dart';
import 'dart:convert';

NotificationPageModel notificationPageModelFromJson(String str) =>
    NotificationPageModel.fromJson(json.decode(str));

class NotificationPageModel {
  int count = 0;
  final List<NotificationModel> notification;

  NotificationPageModel(
    this.notification,
    this.count,
  );

  factory NotificationPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable convertNotification = json['notification'] ?? [];

    final listCategory = convertNotification.map((item) {
      return NotificationModel.fromJson(item);
    }).toList();

    return NotificationPageModel(
      listCategory,
      json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification': notification.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
