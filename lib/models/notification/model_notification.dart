import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  final int id;
  final String title;
  final String subtitle;
  final DateTime date;

  NotificationModel(
    this.id,
    this.title,
    this.subtitle,
    this.date,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      json['id'] as int,
      json['title'] as String,
      json['subtitle'] as String,
      json['date'] != null ? DateTime.tryParse(json['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date.toString(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
