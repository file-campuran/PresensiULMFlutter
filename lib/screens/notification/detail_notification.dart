import "package:flutter/material.dart";
import "package:absen_online/models/model.dart";
import 'package:absen_online/utils/utils.dart';

class DetailNotification extends StatelessWidget {
  final NotificationModel item;
  const DetailNotification({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('notification'),
        ),
      ),
      body: SafeArea(
        child: Text(item.content),
      ),
    );
  }
}
