import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum PageType { map, list }

class Riwayat extends StatefulWidget {
  final String title;

  Riwayat({Key key, this.title = ''}) : super(key: key);

  @override
  _RiwayatState createState() {
    return _RiwayatState();
  }
}

class _RiwayatState extends State<Riwayat> {
  final _controller = RefreshController(initialRefresh: false);
  final _swipeController = SwiperController();

  GoogleMapController _mapController;
  int _indexLocation = 0;
  MapType _mapType = MapType.normal;
  CameraPosition _initPosition;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  PageType _pageType = PageType.list;
  PresensiViewType _modeView = PresensiViewType.list;
  PresensiListModel _presensiList;

  Map<String, dynamic> _errorData;
  bool _btnLoading = false;
  bool _isEmptyListPresensi = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///On Fetch API
  Future<void> _loadData() async {
    setState(() {
      _presensiList = null;
      _btnLoading = true;
    });
    final result = await PresensiRepository().getPresensi();

    if (this.mounted) {
      setState(() {
        _btnLoading = false;
      });

      if (result.code == CODE.SUCCESS) {
        final listProduct = PresensiListModel.fromJson(result.data);
        print(result.data.runtimeType);

        ///Setup list marker map from list
        listProduct.list.forEach((item) {
          imageModel.add(ImageModel.fromJson({
            "id": 1,
            "image": item.fileGambar,
            "description": item.deskripsiKinerja
          }));

          final markerId = MarkerId(item.id.toString());
          final marker = Marker(
            markerId: markerId,
            position: LatLng(item.latitude, item.longitude),
            infoWindow: InfoWindow(title: item.status),
            onTap: () {
              _onSelectLocation(item);
            },
          );
          _markers[markerId] = marker;
        });

        if (listProduct.list.length == 0) {
          setState(() {
            _isEmptyListPresensi = true;
          });
        } else {
          setState(() {
            _errorData = null;
            // _pageType = PageType.map;
            _presensiList = listProduct;
            _initPosition = CameraPosition(
              target: LatLng(
                listProduct.list[0].latitude,
                listProduct.list[0].longitude,
              ),
              zoom: 14.4746,
            );
          });
        }
      } else if (result.code == CODE.TOKEN_EXPIRED) {
        BlocProvider.of<LoginBloc>(context).add(OnLogout());
      } else {
        UtilLogger.log('RESULT', result.toJson());
        setState(() {
          _errorData = result.message;
        });
      }
    }
  }

  ///On Load More
  Future<void> _onLoading() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.loadComplete();
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    await _loadData();
    _controller.refreshCompleted();
  }

  ///Export Icon for Mode View
  IconData _exportIconView() {
    switch (_modeView) {
      case PresensiViewType.list:
        return Icons.view_list;
      case PresensiViewType.gird:
        return Icons.view_quilt;
      case PresensiViewType.block:
        return Icons.view_array;
      default:
        return Icons.help;
    }
  }

  ///On Change View
  void _onChangeView() {
    switch (_modeView) {
      case PresensiViewType.gird:
        _modeView = PresensiViewType.list;
        break;
      case PresensiViewType.list:
        _modeView = PresensiViewType.block;
        break;
      case PresensiViewType.block:
        _modeView = PresensiViewType.gird;
        break;
      default:
        return;
    }
    setState(() {
      _modeView = _modeView;
    });
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
  void _onSelectLocation(PresensiModel item) {
    final index = _presensiList.list.indexOf(item);
    _swipeController.move(index);
  }

  ///Handle Index change list map view
  void _onIndexChange(int index) {
    setState(() {
      _indexLocation = index;
    });

    _markers.forEach((key, value) {
      MarkerId markerId = MarkerId(key.value);
      Marker resetOld = _markers[markerId]
          .copyWith(iconParam: BitmapDescriptor.defaultMarker);

      //ACTIVE
      if (key.value == _presensiList.list[index].id.toString()) {
        resetOld = _markers[markerId].copyWith(
          visibleParam: true,
          // iconParam:
          //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        );
      } else {
        resetOld = _markers[markerId].copyWith(
          visibleParam: false,
          // iconParam:
          //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
      }

      _markers[markerId] = resetOld;
    });

    ///Camera animated
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: LatLng(
            _presensiList.list[_indexLocation].latitude,
            _presensiList.list[_indexLocation].longitude,
          ),
          tilt: 30.0,
          zoom: 15.0,
        ),
      ),
    );
  }

  ///On navigate product detail
  void _onPresensiDetail(PresensiModel item) {
    Navigator.pushNamed(context, Routes.riwayatDetail, arguments: item);
  }

  ///_build Item Loading
  Widget _buildItemLoading(PresensiViewType type) {
    switch (type) {
      case PresensiViewType.gird:
        return FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            padding: EdgeInsets.only(left: 15),
            child: AppPresensiItem(
              type: _modeView,
            ),
          ),
        );

      case PresensiViewType.list:
        return Container(
          padding: EdgeInsets.only(left: 15),
          child: AppPresensiItem(
            type: _modeView,
          ),
        );

      default:
        return AppPresensiItem(
          type: _modeView,
        );
    }
  }

  ///_build Item
  Widget _buildItem(PresensiModel item, PresensiViewType type) {
    switch (type) {
      case PresensiViewType.gird:
        return FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: AppPresensiItem(
              onPressed: _onPresensiDetail,
              item: item,
              type: _modeView,
            ),
          ),
        );

      case PresensiViewType.list:
        return Container(
          padding: EdgeInsets.only(left: 15),
          child: AppPresensiItem(
            onPressed: _onPresensiDetail,
            item: item,
            type: _modeView,
          ),
        );

      default:
        return AppPresensiItem(
          onPressed: _onPresensiDetail,
          item: item,
          type: _modeView,
        );
    }
  }

  List<ImageModel> imageModel = [];

  ///On navigate gallery
  void _onPhotoPreview() {
    Navigator.pushNamed(
      context,
      Routes.gallery,
      arguments: imageModel,
    );
  }

  ///Widget build Content
  Widget _buildList() {
    if (_isEmptyListPresensi) {
      return Center(
        child: AppInfo(
          title: 'Informasi',
          message: 'Data Presensi Kosong',
          image: Images.Empty,
        ),
      );
    }

    if (_errorData != null) {
      return Center(
        child: AppError(
          title: _errorData['title'].toString(),
          message: _errorData['content'],
          image: _errorData['image'],
          onPress: _loadData,
          btnRefreshLoading: _btnLoading,
        ),
      );
    }

    if (_presensiList?.list == null) {
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
      children: _presensiList.list.map((item) {
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
          enablePullUp: false,
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
              // left: _modeView == PresensiViewType.block ? 0 : 5,
              // right: _modeView == PresensiViewType.block ? 0 : 20,
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
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Swiper(
                      itemBuilder: (context, index) {
                        final PresensiModel item = _presensiList.list[index];
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
                            child: AppPresensiItem(
                              onPressed: _onPresensiDetail,
                              item: item,
                              type: PresensiViewType.list,
                            ),
                          ),
                        );
                      },
                      controller: _swipeController,
                      onIndexChanged: (index) {
                        _onIndexChange(index);
                      },
                      itemCount: _presensiList.list.length,
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
      appBar: AppCustomAppBar.defaultAppBar(
          title: Translate.of(context).translate('attendance_history'),
          actions: <Widget>[
            Visibility(
              visible: _presensiList?.list?.length != null,
              child: IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: _onPhotoPreview,
              ),
            )
            // IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: _onSearch,
            // ),
            // Visibility(
            //   visible: _presensiList?.list != null,
            //   child: IconButton(
            //     icon: Icon(
            //       _pageType == PageType.map ? Icons.view_compact : Icons.map,
            //     ),
            //     onPressed: _onChangePageStyle,
            //   ),
            // )
          ],
          context: context),
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
                      Text(
                        Translate.of(context).translate('change_view'),
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Visibility(
                        visible: _presensiList?.list != null,
                        child: InkWell(
                          onTap: _onChangePageStyle,
                          child: Row(
                            children: [
                              Icon(
                                _pageType == PageType.map
                                    ? Icons.view_compact
                                    : Icons.map,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                child: Text(
                                  _pageType == PageType.map
                                      ? Translate.of(context).translate('list')
                                      : Translate.of(context).translate('map'),
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
