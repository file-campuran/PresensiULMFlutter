import 'dart:io';

import 'package:absen_online/models/model.dart';

enum Status { sent, received }
enum Type { textMessage, photo }

class MessageModel {
  final int id;
  final String roomName;
  final List<UserModel> member;
  final UserModel from;
  final String message;
  final DateTime date;
  final Status status;
  final File file;
  final Type type;

  MessageModel(
    this.id,
    this.roomName,
    this.member,
    this.from,
    this.message,
    this.date,
    this.status,
    this.file,
    this.type,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    Status status = Status.sent;
    File file;
    Type type = Type.textMessage;
    List<UserModel> member;
    UserModel from;

    if (json['status'] == 'received') {
      status = Status.received;
    }

    if (json['file'] != null) {
      file = File(json['file']);
      type = Type.photo;
    }

    if (json['member'] != null) {
      final Iterable convertUser = json['member'] ?? [];
      member = convertUser.map((item) {
        return UserModel.fromJson(item);
      }).toList();
    }

    if (json['from'] != null) {
      from = UserModel.fromJson(json['from']);
    }

    return MessageModel(
      json['id'] as int ?? 0,
      json['room_name'] as String ?? '',
      member,
      from,
      json['message'] as String ?? 'Unknown',
      DateTime.tryParse(json['date']) ?? DateTime.now(),
      status,
      file,
      type,
    );
  }
}
