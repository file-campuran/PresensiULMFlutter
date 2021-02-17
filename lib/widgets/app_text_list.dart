import 'package:flutter/material.dart';

class AppTextList extends StatelessWidget {
  final String text;
  final bool withIndicator;

  AppTextList(this.text, {this.withIndicator = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (withIndicator) ...[
          Container(
            margin: EdgeInsets.only(top: 5),
            height: 8,
            width: 8,
            decoration: new BoxDecoration(
                shape: BoxShape.circle, color: Theme.of(context).primaryColor),
          ),
          SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.clip,
            style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
          ),
        )
      ],
    );
  }
}
