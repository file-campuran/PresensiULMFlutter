import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String message, desc;
  final bool center;
  final EdgeInsetsGeometry margin;
  final bool isFlare;
  final String image;

  /// * [message] type String must not be null.
  /// * [desc] type String.
  /// * [margin] type from class EdgeInsetsGeometry.
  /// * [isFlare] type bool default value is true.
  /// * [center] type bool default value is true.
  /// * [image] type String must not be null if [isFlare] is false.
  EmptyData(
      {this.message,
      this.desc,
      this.center = true,
      this.margin,
      this.isFlare = true,
      this.image});

  @override
  Widget build(BuildContext context) {
    if (center) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              child: Image.asset(image),
            ),
            Text(message,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(desc == null ? '' : desc,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
            )
          ],
        ),
      );
    } else {
      return Container(
        alignment: Alignment.topCenter,
        margin: margin,
        child: Column(
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              child: Image.asset(image),
            ),
            Text(message,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(desc == null ? '' : desc,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
            )
          ],
        ),
      );
    }
  }
}
