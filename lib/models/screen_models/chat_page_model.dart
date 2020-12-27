import 'package:absen_online/models/model.dart';

class ChatPageModel {
  final String roomName;
  final int online;
  final List<UserModel> member;
  final List<MessageModel> message;

  ChatPageModel(
    this.roomName,
    this.online,
    this.member,
    this.message,
  );

  factory ChatPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable convertMessage = json['message'] ?? [];

    final listMessage = convertMessage.map((item) {
      return MessageModel.fromJson(item);
    }).toList();

    final Iterable convertUser = json['member'] ?? [];

    final listUser = convertUser.map((item) {
      return UserModel.fromJson(item);
    }).toList();

    return ChatPageModel(
      json['room_name'] as String ?? '',
      json['online'] as int ?? 0,
      listUser,
      listMessage,
    );
  }
}
