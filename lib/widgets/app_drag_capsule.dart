import 'package:flutter/material.dart';

class AppDragCapsule extends StatelessWidget {
  const AppDragCapsule({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }
}
