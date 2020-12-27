import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';

class ProductHeader extends SliverPersistentHeaderDelegate {
  final double height;
  final ProductDetailTabPageModel productTabPage;
  final bool like;
  final VoidCallback onPressLike;
  final VoidCallback onPressReview;

  ProductHeader({
    this.height,
    this.productTabPage,
    this.like,
    this.onPressLike,
    this.onPressReview,
  });

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    ///Build info
    Widget information() {
      if (productTabPage == null) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                ),
                height: 10,
                width: 150,
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        height: 20,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                    width: 100,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                productTabPage?.product?.title,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: Icon(
                  like ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: onPressLike,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: onPressReview,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productTabPage?.product?.subtitle,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppTag(
                          "${productTabPage?.product?.rate}",
                          type: TagType.rateSmall,
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        StarRating(
                          rating: productTabPage?.product?.rate,
                          size: 14,
                          color: AppTheme.yellowColor,
                          borderColor: AppTheme.yellowColor,
                          onRatingChanged: (v) {
                            onPressReview();
                          },
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Text(
                          "(${productTabPage?.product?.numRate})",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              productTabPage?.product?.status != null
                  ? AppTag(
                      productTabPage?.product?.status,
                      type: TagType.status,
                    )
                  : Container(),
            ],
          ),
        ],
      );
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
        ),
        child: Column(
          children: <Widget>[
            AppUserInfo(
              user: productTabPage?.product?.author,
              onPressed: () {},
              type: AppUserType.basic,
            ),
            information(),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
