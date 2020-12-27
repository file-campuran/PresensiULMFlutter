import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/screens/chat/receive_message.dart';
import 'package:absen_online/screens/chat/send_message.dart';

class ChatItem extends StatelessWidget {
  final MessageModel item;

  ChatItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.from == null) {
      return SendMessage(item: item);
    }

    return ReceiveMessage(item: item);
  }
}
