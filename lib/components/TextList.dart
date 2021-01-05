import 'package:flutter/material.dart';

class TextList extends StatelessWidget {
  final String text;
  const TextList(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5),
          height: 8,
          width: 8,
          decoration: new BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.clip,
          ),
        )
      ],
    );
  }
}
