import 'package:absen_online/widgets/app_presensi_item.dart';
import 'package:absen_online/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppTimmer extends StatelessWidget {
  final String title;
  final String start;
  final String end;
  final String timeLeft;
  final String text;
  final bool isChecked;
  final AppPresensiItem item;

  /// Widget Timmer.
  ///
  /// ![GAMBAR](docs/widget/app_timmer.jpg)
  ///
  /// See also:
  ///  * [transparent], a fully-transparent color.
  const AppTimmer({
    Key key,
    this.title = 'Presensi',
    this.text = 'Sisa Waktu',
    this.isChecked = false,
    this.start = '00:00',
    this.end = '00:00',
    this.timeLeft = "5 jam 35 menit",
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 7, bottom: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor.withOpacity(0.8)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.grey, width: 0.2),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.padding, vertical: Dimens.padding),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              toBeginningOfSentenceCase(title) + '  ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            // Icon(
                            //   Icons.notification_important,
                            //   size: 16,
                            //   color: Colors.green,
                            // ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.check_circle,
                                size: 25,
                                color: isChecked ? Colors.green : Colors.grey)
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Mulai",
                              style: TextStyle(fontSize: 9),
                            ),
                            Text(
                              start,
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(width: 4),
                        Container(
                          height: 7,
                          width: 7,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                        ),
                        Text(
                          ' - - - - - - - - - - ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(
                          height: 7,
                          width: 7,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                        ),
                        SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Selesai",
                              style: TextStyle(fontSize: 9),
                            ),
                            Text(
                              end,
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    item != null
                        ? Container()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 8),
                                    padding: EdgeInsets.only(
                                        left: 6, right: 6, top: 3, bottom: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2),
                                    ),
                                    child: Text(
                                        timeLeft == 'null'
                                            ? "Waktu Presensi Berakhir"
                                            : 'Sisa waktu',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                  Text(
                                    timeLeft == 'null' ? "" : timeLeft,
                                    style: TextStyle(
                                        fontSize: 9, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    item ?? Container(),
                  ])),
            ),
          ],
        ));
  }
}
