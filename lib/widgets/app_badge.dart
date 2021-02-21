import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final Function onTap;
  final String title;
  const AppBadge({Key key, this.onTap, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(width: 0.5, color: Theme.of(context).primaryColor),
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
