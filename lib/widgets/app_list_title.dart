import 'package:flutter/material.dart';

class AppListTitle extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback onPressed;
  final bool border;
  final TextStyle textStyle;

  AppListTitle({
    Key key,
    this.title,
    this.trailing,
    this.onPressed,
    this.border = true,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                title,
                style: textStyle ?? Theme.of(context).textTheme.subtitle1,
              ),
            ),
            trailing ?? Container()
          ],
        ),
      ),
    );
  }
}
