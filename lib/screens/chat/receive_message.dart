import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/widgets/widget.dart';

class ReceiveMessage extends StatelessWidget {
  final MessageModel item;

  ReceiveMessage({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          AppCircleAvatar(
            imgUrl: item.from.image,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    item.from.name,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .5,
                    maxHeight: MediaQuery.of(context).size.height * .3,
                  ),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    image: item.type == Type.photo
                        ? DecorationImage(
                            image: AssetImage(
                              item.file.path,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: item.type == Type.textMessage
                      ? Text(
                          item.message,
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      : null,
                ),
              ],
            ),
          ),
          Text(
            DateFormat(
              'EEE MMM d yyyy',
              AppLanguage.defaultLanguage.languageCode,
            ).format(item.date),
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
