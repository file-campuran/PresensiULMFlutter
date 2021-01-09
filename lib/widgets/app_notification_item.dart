import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:shimmer/shimmer.dart';

class AppNotificationItem extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onPressed;
  final bool border;

  AppNotificationItem({
    Key key,
    this.item,
    this.onPressed,
    this.border = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return Shimmer.fromColors(
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, right: 20, left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 10,
                            width: 150,
                            color: Colors.white,
                          ),
                          Container(
                            height: 10,
                            width: 50,
                            color: Colors.white,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        height: 10,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
      );
    }
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
        decoration: BoxDecoration(
          border: border
              ? Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.isRead
                    ? Theme.of(context).primaryColor
                    : Colors.greenAccent,
              ),
              child: Icon(
                Icons.timelapse,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.subtitle2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat(
                            'hh:mm, MMM dd yyyy',
                            AppLanguage.defaultLanguage.languageCode,
                          ).format(item.date),
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                    ),
                    // Html(
                    //   useRichText: false,
                    //   data: item.content
                    //       .substring(0, 60)
                    //       .replaceAll('\n', '</br>'),
                    //   showImages: false,
                    //   defaultTextStyle: Theme.of(context)
                    //       .textTheme
                    //       .caption
                    //       .copyWith(fontWeight: FontWeight.w500),
                    //   customTextAlign: (dom.Node node) {
                    //     return TextAlign.left;
                    //   },
                    // ),
                    Text(
                      item.content,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
