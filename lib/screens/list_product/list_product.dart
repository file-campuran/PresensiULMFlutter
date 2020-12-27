import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum PageType { map, list }

class ListProduct extends StatefulWidget {
  final String title;

  ListProduct({Key key, this.title = 'Place'}) : super(key: key);

  @override
  _ListProductState createState() {
    return _ListProductState();
  }
}

class _ListProductState extends State<ListProduct> {
  final _controller = RefreshController(initialRefresh: false);
  final _swipeController = SwiperController();

  GoogleMapController _mapController;
  int _indexLocation = 0;
  MapType _mapType = MapType.normal;
  CameraPosition _initPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  PageType _pageType = PageType.list;
  ProductViewType _modeView = ProductViewType.gird;
  ProductListPageModel _productList;
  SortModel _currentSort = AppSort.defaultSort;
  List<SortModel> _listSort = AppSort.listSortDefault;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///On Fetch API
  Future<void> _loadData() async {
    final ResultApiModel result = await Api.getProduct();
    if (result.success) {
      final listProduct = ProductListPageModel.fromJson(result.data);

      ///Setup list marker map from list
      listProduct.list.forEach((item) {
        final markerId = MarkerId(item.id.toString());
        final marker = Marker(
          markerId: markerId,
          position: LatLng(item.location.lat, item.location.long),
          infoWindow: InfoWindow(title: item.title),
          onTap: () {
            _onSelectLocation(item);
          },
        );
        _markers[markerId] = marker;
      });

      setState(() {
        _productList = listProduct;
        _initPosition = CameraPosition(
          target: LatLng(
            listProduct.list[0].location.lat,
            listProduct.list[0].location.long,
          ),
          zoom: 14.4746,
        );
      });
    }
  }

  ///On Load More
  Future<void> _onLoading() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.loadComplete();
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.refreshCompleted();
  }

  ///On Change Sort
  void _onChangeSort() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return AppModelBottomSheet(
          selected: _currentSort,
          option: _listSort,
          onChange: (item) {
            setState(() {
              _currentSort = item;
            });
          },
        );
      },
    );
  }

  ///On Change View
  void _onChangeView() {
    switch (_modeView) {
      case ProductViewType.gird:
        _modeView = ProductViewType.list;
        break;
      case ProductViewType.list:
        _modeView = ProductViewType.block;
        break;
      case ProductViewType.block:
        _modeView = ProductViewType.gird;
        break;
      default:
        return;
    }
    setState(() {
      _modeView = _modeView;
    });
  }

  ///On change filter
  void _onChangeFilter() {
    Navigator.pushNamed(context, Routes.filter);
  }

  ///On change page
  void _onChangePageStyle() {
    switch (_pageType) {
      case PageType.list:
        setState(() {
          _pageType = PageType.map;
        });
        return;
      case PageType.map:
        setState(() {
          _pageType = PageType.list;
        });
        return;
    }
  }

  ///On change map style
  void _onChangeMapStyle() {
    MapType type = _mapType;
    switch (_mapType) {
      case MapType.normal:
        type = MapType.hybrid;
        break;
      case MapType.hybrid:
        type = MapType.normal;
        break;
      default:
        type = MapType.normal;
        break;
    }
    setState(() {
      _mapType = type;
    });
  }

  ///On tap marker map location
  void _onSelectLocation(ProductModel item) {
    final index = _productList.list.indexOf(item);
    _swipeController.move(index);
  }

  ///Handle Index change list map view
  void _onIndexChange(int index) {
    setState(() {
      _indexLocation = index;
    });

    ///Camera animated
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: LatLng(
            _productList.list[_indexLocation].location.lat,
            _productList.list[_indexLocation].location.long,
          ),
          tilt: 30.0,
          zoom: 15.0,
        ),
      ),
    );
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    String route = item.type == ProductType.place
        ? Routes.productDetail
        : Routes.productDetailTab;
    Navigator.pushNamed(context, route, arguments: item.id);
  }

  ///On search
  void _onSearch() {
    Navigator.pushNamed(context, Routes.searchHistory);
  }

  ///Export Icon for Mode View
  IconData _exportIconView() {
    switch (_modeView) {
      case ProductViewType.list:
        return Icons.view_list;
      case ProductViewType.gird:
        return Icons.view_quilt;
      case ProductViewType.block:
        return Icons.view_array;
      default:
        return Icons.help;
    }
  }

  ///_build Item Loading
  Widget _buildItemLoading(ProductViewType type) {
    switch (type) {
      case ProductViewType.gird:
        return FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            padding: EdgeInsets.only(left: 15),
            child: AppProductItem(
              type: _modeView,
            ),
          ),
        );

      case ProductViewType.list:
        return Container(
          padding: EdgeInsets.only(left: 15),
          child: AppProductItem(
            type: _modeView,
          ),
        );

      default:
        return AppProductItem(
          type: _modeView,
        );
    }
  }

  ///_build Item
  Widget _buildItem(ProductModel item, ProductViewType type) {
    switch (type) {
      case ProductViewType.gird:
        return FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            padding: EdgeInsets.only(left: 15),
            child: AppProductItem(
              onPressed: _onProductDetail,
              item: item,
              type: _modeView,
            ),
          ),
        );

      case ProductViewType.list:
        return Container(
          padding: EdgeInsets.only(left: 15),
          child: AppProductItem(
            onPressed: _onProductDetail,
            item: item,
            type: _modeView,
          ),
        );

      default:
        return AppProductItem(
          onPressed: _onProductDetail,
          item: item,
          type: _modeView,
        );
    }
  }

  ///Widget build Content
  Widget _buildList() {
    if (_productList?.list == null) {
      ///Build Loading
      return Wrap(
        runSpacing: 15,
        alignment: WrapAlignment.spaceBetween,
        children: List.generate(8, (index) => index).map((item) {
          return _buildItemLoading(_modeView);
        }).toList(),
      );
    }

    ///Build list
    return Wrap(
      runSpacing: 15,
      alignment: WrapAlignment.spaceBetween,
      children: _productList.list.map((item) {
        return _buildItem(item, _modeView);
      }).toList(),
    );
  }

  ///Build Content Page Style
  Widget _buildContent() {
    if (_pageType == PageType.list) {
      return SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _controller,
          header: ClassicHeader(
            idleText: Translate.of(context).translate('pull_down_refresh'),
            refreshingText: Translate.of(context).translate('refreshing'),
            completeText: Translate.of(context).translate('refresh_completed'),
            releaseText: Translate.of(context).translate('release_to_refresh'),
            refreshingIcon: SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          footer: ClassicFooter(
            loadingText: Translate.of(context).translate('loading'),
            canLoadingText: Translate.of(context).translate(
              'release_to_load_more',
            ),
            idleText: Translate.of(context).translate('pull_to_load_more'),
            loadStyle: LoadStyle.ShowWhenLoading,
            loadingIcon: SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: _modeView == ProductViewType.block ? 0 : 5,
              right: _modeView == ProductViewType.block ? 0 : 20,
              bottom: 15,
            ),
            child: _buildList(),
          ),
        ),
      );
    }

    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            mapType: _mapType,
            initialCameraPosition: _initPosition,
            markers: Set<Marker>.of(_markers.values),
            myLocationEnabled: false,
          ),
          SafeArea(
            bottom: false,
            top: false,
            child: Container(
              height: 210,
              margin: EdgeInsets.only(bottom: 15),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 36,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).dividerColor,
                                blurRadius: 5,
                                spreadRadius: 1.0,
                                offset: Offset(1.5, 1.5),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.directions,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).dividerColor,
                                  blurRadius: 5,
                                  spreadRadius: 1.0,
                                  offset: Offset(1.5, 1.5),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Swiper(
                      itemBuilder: (context, index) {
                        final ProductModel item = _productList.list[index];
                        return Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _indexLocation == index
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).dividerColor,
                                  blurRadius: 5,
                                  spreadRadius: 1.0,
                                  offset: Offset(1.5, 1.5),
                                )
                              ],
                            ),
                            child: AppProductItem(
                              onPressed: _onProductDetail,
                              item: item,
                              type: ProductViewType.list,
                            ),
                          ),
                        );
                      },
                      controller: _swipeController,
                      onIndexChanged: (index) {
                        _onIndexChange(index);
                      },
                      itemCount: _productList.list.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearch,
          ),
          Visibility(
            visible: _productList?.list != null,
            child: IconButton(
              icon: Icon(
                _pageType == PageType.map ? Icons.view_compact : Icons.map,
              ),
              onPressed: _onChangePageStyle,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SafeArea(
            top: false,
            bottom: false,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(_currentSort.icon),
                        onPressed: _onChangeSort,
                      ),
                      Text(
                        Translate.of(context).translate(_currentSort.name),
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Visibility(
                        visible: _pageType == PageType.list,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(_exportIconView()),
                              onPressed: _onChangeView,
                            ),
                            Container(
                              height: 24,
                              child: VerticalDivider(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _pageType != PageType.list,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                _mapType == MapType.normal
                                    ? Icons.satellite
                                    : Icons.map,
                              ),
                              onPressed: _onChangeMapStyle,
                            ),
                            Container(
                              height: 24,
                              child: VerticalDivider(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.track_changes),
                        onPressed: _onChangeFilter,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: Text(
                          Translate.of(context).translate('filter'),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildContent(),
          )
        ],
      ),
    );
  }
}
