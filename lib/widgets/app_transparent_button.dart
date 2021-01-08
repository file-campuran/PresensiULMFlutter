import 'package:flutter/material.dart';

class AppTransparentButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Function onTap;
  final bool isLoading;
  final bool background;
  const AppTransparentButton(
      {Key key,
      this.background = true,
      this.icon,
      this.isLoading = false,
      this.onTap,
      this.size = 55})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(16.0),
        child: !isLoading
            ? Icon(
                icon,
                size: size / 2.5,
                color: Colors.white,
              )
            : CircularProgressIndicator(),
        decoration: background
            ? BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                shape: BoxShape.circle,
              )
            : BoxDecoration(),
      ),
    );
  }
}
