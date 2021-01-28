import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  final String id;
  int isRead;
  final String title;
  final String content;
  final DateTime date;

  NotificationModel({
    this.id,
    this.isRead,
    this.title,
    this.content,
    this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"].toString(),
        isRead: json["isRead"] ?? 0,
        title: json["title"],
        content: json["content"] ?? '',
        date: json['date'] != null
            ? DateTime.tryParse(json['date'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isRead': isRead,
      'title': title,
      'content': content,
      'date': date.toString(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
