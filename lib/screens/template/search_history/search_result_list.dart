import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'tab_bar_search.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';

const tabHeight = 50.0;

class ResultList extends StatefulWidget {
  final String query;
  final double statusBarHeight;

  ResultList({
    Key key,
    this.query,
    this.statusBarHeight,
  }) : super(key: key);

  @override
  _ResultListState createState() {
    return _ResultListState();
  }
}

class _ResultListState extends State<ResultList> {
  final _tabController = ScrollController();
  final _scrollController = ScrollController();

  List<double> _offsetContentOrigin = [];
  int _indexTab = 0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  ///ScrollListenerEvent
  void _scrollListener() {
    int activeTab = 0;
    double offsetTab;
    double widthDevice = MediaQuery.of(context).size.width;
    double itemSize = widthDevice / 3;
    double offsetStart = widthDevice / 2 - itemSize / 2;

    int indexCheck = _offsetContentOrigin.indexWhere((item) {
      return item - 1 > _scrollController.offset;
    });
    if (indexCheck == -1) {
      activeTab = _offsetContentOrigin.length - 1;
      offsetTab = offsetStart + itemSize * (activeTab - 3);
    } else if (indexCheck > 0) {
      activeTab = indexCheck - 1 > 0 ? indexCheck - 1 : 0;
      offsetTab = activeTab > 1 ? offsetStart + itemSize * (activeTab - 2) : 0;
    }

    if (activeTab != _indexTab) {
      setState(() {
        _indexTab = activeTab;
      });
    }
    if (offsetTab != null) {
      _tabController.jumpTo(offsetTab);
    }
  }

  ///Set Origin Offset default when render success
  void _setOriginOffset(List<TabModel> list) {
    if (list != null && _offsetContentOrigin.isEmpty) {
      setState(() {
        _offsetContentOrigin = list.map((item) {
          final RenderBox box =
              item.keyContentItem.currentContext.findRenderObject();
          final position = box.localToGlobal(Offset.zero);
          return position.dy -
              tabHeight -
              AppBar().preferredSize.height -
              widget.statusBarHeight;
        }).toList();
      });
    }
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    String route = item.type == ProductType.place
        ? Routes.productDetail
        : Routes.productDetailTab;
    Navigator.pushNamed(context, route, arguments: item.id);
  }

  ///On Change tab jumpTo offset
  ///Scroll controller will handle setState active tab
  void _onChangeTab(int index) {
    if (_offsetContentOrigin.isNotEmpty) {
      _scrollController.animateTo(
        _offsetContentOrigin[index] + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Widget _renderList(TabModel tab) {
    switch (tab.key) {
      case "hotel":
        return Container(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20),
            itemBuilder: (context, index) {
              final ProductModel item = tab.list[index];
              return Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.only(right: 15),
                child: AppProductItem(
                  onPressed: _onProductDetail,
                  item: item,
                  type: ProductViewType.gird,
                ),
              );
            },
            itemCount: tab.list.length,
          ),
        );

      case "shop":
        return Container(
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20),
            itemBuilder: (context, index) {
              final ProductModel item = tab.list[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.only(right: 15),
                child: AppProductItem(
                  onPressed: _onProductDetail,
                  item: item,
                  type: ProductViewType.list,
                ),
              );
            },
            itemCount: tab.list.length,
          ),
        );

      case "estate":
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: tab.list.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: AppProductItem(
                  onPressed: (item) {},
                  item: item,
                  type: ProductViewType.small,
                ),
              );
            }).toList(),
          ),
        );

      default:
        return Container(
          height: 170,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 5, right: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = tab.list[index];
              return Padding(
                padding: EdgeInsets.only(left: 15),
                child: SizedBox(
                  width: 135,
                  height: 160,
                  child: AppProductItem(
                    item: item,
                    type: ProductViewType.cardLarge,
                    onPressed: _onProductDetail,
                  ),
                ),
              );
            },
            itemCount: tab.list.length,
          ),
        );
    }
  }

  Widget _renderContentTab(List<TabModel> listTab) {
    if (listTab == null) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        enabled: true,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(left: 20, right: 20),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        final item = listTab[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              key: item.keyContentItem,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 15,
                top: 15,
              ),
              child: Text(
                item.title,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            _renderList(item),
            index != listTab.length - 1
                ? Container(
                    height: 15,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        );
      },
      itemCount: listTab.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is Success) {
            if (state.listTab.length == 0) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.sentiment_satisfied),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(
                        Translate.of(context).translate('category_not_found'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              );
            }
            Timer(Duration(milliseconds: 250), () {
              _setOriginOffset(state.listTab);
            });
            return Column(
              children: <Widget>[
                Container(
                  height: tabHeight,
                  child: TabBarSearch(
                    tabController: _tabController,
                    onIndexChanged: _onChangeTab,
                    indexTab: _indexTab,
                    tab: state?.listTab,
                  ),
                ),
                Expanded(child: _renderContentTab(state?.listTab)),
              ],
            );
          }

          if (state is Searching) {
            return Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
