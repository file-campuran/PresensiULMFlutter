import 'package:absen_online/models/model.dart';

class MessageDetailPageModel {
  final List<MessageModel> message;

  MessageDetailPageModel(
    this.message,
  );

  factory MessageDetailPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable convertMessage = json['message'] ?? [];

    final listMessage = convertMessage.map((item) {
      return MessageModel.fromJson(item);
    }).toList();

    return MessageDetailPageModel(
      listMessage,
    );
  }
}
