import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class ProductTabBar extends SliverPersistentHeaderDelegate {
  final double height;
  final ScrollController tabController;
  final ValueChanged<int> onIndexChanged;
  final List<TabModel> tab;
  final int indexTab;

  ProductTabBar({
    this.height,
    this.tabController,
    this.onIndexChanged,
    this.tab,
    this.indexTab,
  });

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    if (tab == null) {
      return SafeArea(
        top: false,
        bottom: false,
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          enabled: true,
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 20, right: 20),
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          controller: tabController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final item = tab[index];
            final active = indexTab == index;
            return InkWell(
              onTap: () {
                onIndexChanged(index);
              },
              child: Container(
                key: item.keyTabItem,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3,
                padding: EdgeInsets.only(top: 3, left: 8, right: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: active
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  Translate.of(context).translate(item.title),
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: active ? FontWeight.w600 : null,
                      ),
                ),
              ),
            );
          },
          itemCount: tab.length,
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
