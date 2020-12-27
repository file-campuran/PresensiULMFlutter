import 'package:absen_online/models/model.dart';

class MessagePageModel {
  final List<MessageModel> message;

  MessagePageModel(
    this.message,
  );

  factory MessagePageModel.fromJson(Map<String, dynamic> json) {
    final Iterable convertMessage = json['message'] ?? [];

    final listMessage = convertMessage.map((item) {
      return MessageModel.fromJson(item);
    }).toList();

    return MessagePageModel(
      listMessage,
    );
  }
}
