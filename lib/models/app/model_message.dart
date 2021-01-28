import 'dart:convert';
import 'package:absen_online/utils/utils.dart';

List<MessageModel> listMessageFromJson(String str) => List<MessageModel>.from(
    json.decode(str).map((x) => MessageModel.fromJson(x)));

MessageModel messageFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

class MessageModel {
  String id;
  String content;
  String title;
  String publishedAt;
  int readAt;

  MessageModel(
      {this.id, this.content, this.title, this.publishedAt, this.readAt});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        content: json["content"],
        title: json["title"],
        publishedAt: json["published_at"],
        readAt: json["read_at"] == null ? 0 : json["read_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "title": title,
        "published_at": publishedAt,
        "read_at": readAt,
      };

  String humanDate() {
    try {
      return unixTimeStampToDateDocs(
          DateTime.parse(publishedAt).millisecondsSinceEpoch);
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
