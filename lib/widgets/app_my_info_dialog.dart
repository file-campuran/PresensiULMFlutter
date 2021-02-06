import 'package:flutter/material.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/configs/config.dart';

Future appMyInfoDialog(
    {@required BuildContext context, String title, dynamic message}) {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Respon Server'),
          content: SingleChildScrollView(
            child: _buildWidget(message),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

Widget _buildWidget(dynamic message) {
  List<String> error = [];
  if (message is Map) {
    message.forEach((k, v) => error.add('$v'));
  }

  if (message is String) {
    return AppTextList(message);
  } else if (message['content'] != null) {
    return AppTextList(message['content']);
    return AppInfo(
        message: message['content'],
        title: message['title'],
        image: Images.Warning);
  }

  return ListBody(
    children: error
        .map(
          (e) => AppTextList(e),
        )
        .toList(),
  );
}
