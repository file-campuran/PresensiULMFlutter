import 'package:absen_online/widgets/app_presensi_item.dart';
import 'package:absen_online/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';

class AppTimmer extends StatelessWidget {
  final String title;
  final String start;
  final String end;
  final String timeLeft;
  final String text;
  final String tanggal;
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
    this.tanggal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 7, bottom: 7),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor.withOpacity(1)
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
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(EvaIcons.checkmarkCircle2,
                                size: 25,
                                color: isChecked ? Colors.green : Colors.grey)
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(EvaIcons.calendarOutline,
                                    size: 13,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color),
                                SizedBox(width: 2),
                                Text(
                                  tanggal,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pukul',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(EvaIcons.clockOutline,
                                    size: 13,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color),
                                SizedBox(width: 2),
                                Text(
                                  "$start s.d $end",
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
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
                                          .withOpacity(0.15),
                                    ),
                                    child: Text(
                                        timeLeft == 'null'
                                            ? "Waktu Presensi Berakhir"
                                            : 'Sisa waktu',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 11,
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
