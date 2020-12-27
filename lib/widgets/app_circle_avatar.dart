import 'package:flutter/material.dart';

class AppCircleAvatar extends StatelessWidget {
  final String imgUrl;
  final double size;

  const AppCircleAvatar({
    Key key,
    @required this.imgUrl,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            offset: Offset(0, 2),
            blurRadius: 5,
          )
        ],
        image: DecorationImage(
          image: AssetImage(imgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
