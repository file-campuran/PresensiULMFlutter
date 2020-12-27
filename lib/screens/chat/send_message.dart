import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';

class SendMessage extends StatelessWidget {
  final MessageModel item;

  SendMessage({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            DateFormat(
              'EEE MMM d yyyy',
              AppLanguage.defaultLanguage.languageCode,
            ).format(item.date),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .5,
              maxHeight: MediaQuery.of(context).size.width * .3,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
              ),
            ),
            child: item.type == Type.photo
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    child: Image.file(
                      item.file,
                      fit: BoxFit.contain,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      item.message,
                      style: Theme.of(context).textTheme.bodyText1.apply(
                            color: Colors.white,
                          ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
