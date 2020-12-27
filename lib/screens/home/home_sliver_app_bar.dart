import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/screens/home/home_swiper.dart';
import 'package:absen_online/utils/utils.dart';

class AppBarHomeSliver extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final List<ImageModel> banners;

  AppBarHomeSliver({this.expandedHeight, this.banners});

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: HomeSwipe(
            images: banners,
            height: expandedHeight,
          ),
        ),
        Container(
          height: 44,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.searchHistory);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hoverColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                Translate.of(context).translate(
                                  'search_location',
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            VerticalDivider(),
                            Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
