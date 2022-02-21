import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppSkeleton extends StatelessWidget {
  final double height, width, padding, margin;
  final Widget child;
  final BorderRadius borderRadius;

  AppSkeleton({
    Key key,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.borderRadius,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).highlightColor,
      highlightColor: Colors.white,
      child: child != null
          ? child
          : Container(
              height: height,
              padding: padding != null
                  ? EdgeInsets.all(padding)
                  : EdgeInsets.all(0.0),
              margin: EdgeInsets.all(margin ?? 0),
              width: width,
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: borderRadius,
              ),
            ),
    );
  }
}
