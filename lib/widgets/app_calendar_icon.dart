import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class AppCalendarIcon extends StatelessWidget {
  final DateTime date;
  const AppCalendarIcon({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return AppSkeleton(
        child: Container(
          margin: EdgeInsets.only(right: 10.0, top: 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).highlightColor,
          ),
          width: 50,
          height: 50,
        ),
      );
    }

    final data = unixTimeStampToDateAndDayName(date.millisecondsSinceEpoch);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey[300]),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            width: double.infinity,
            child: Text(
              data['dayName'],
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: Center(
            child: Text(
              data['date'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ))
        ],
      ),
    );
  }
}
