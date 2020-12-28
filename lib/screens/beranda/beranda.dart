import 'package:flutter/material.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'beranda_category_item.dart';
import 'beranda_category_list.dart';
import 'beranda_sliver_app_bar.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:timelines/timelines.dart';

class Beranda extends StatefulWidget {
  Beranda({Key key}) : super(key: key);

  @override
  _BerandaState createState() {
    return _BerandaState();
  }
}

class _BerandaState extends State<Beranda> {
  HomePageModel _homePage;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///On select category
  void _onTapService(CategoryModel item) {
    switch (item.type) {
      case ProductType.more:
        _onOpenMore();
        break;

      default:
        Navigator.pushNamed(context, Routes.listProduct, arguments: item.title);
        break;
    }
  }

  ///On Open More
  void _onOpenMore() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return HomeCategoryList(
          category: _homePage?.category,
          onOpenList: () async {
            Navigator.pushNamed(context, Routes.category);
          },
          onPress: (item) async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 250));
            _onTapService(item);
          },
        );
      },
    );
  }

  ///Fetch API
  Future<void> _loadData() async {
    final ResultApiModel result = await Api.getHome();
    if (result.success) {
      setState(() {
        _homePage = HomePageModel.fromJson(result.data);
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

  ///Build category UI
  Widget _buildCategory() {
    if (_homePage?.category == null) {
      return Wrap(
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(8, (index) => index).map(
          (item) {
            return HomeCategoryItem();
          },
        ).toList(),
      );
    }

    List<CategoryModel> listBuild = _homePage.category;

    final more = CategoryModel.fromJson({
      "id": 9,
      "title": Translate.of(context).translate("more"),
      "icon": "more_horiz",
      "color": "#ff8a65",
      "type": "more"
    });

    if (_homePage.category.length > 7) {
      listBuild = _homePage.category.take(7).toList();
      listBuild.add(more);
    }

    return Wrap(
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: listBuild.map(
        (item) {
          return HomeCategoryItem(
            item: item,
            onPressed: (item) {
              _onTapService(item);
            },
          );
        },
      ).toList(),
    );
  }

  ///Build popular UI
  Widget _buildPopular() {
    if (_homePage?.popular == null) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 15),
            child: AppProductItem(
              type: ProductViewType.cardLarge,
            ),
          );
        },
        itemCount: List.generate(8, (index) => index).length,
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
      itemBuilder: (context, index) {
        final item = _homePage.popular[index];
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
      itemCount: _homePage.popular.length,
    );
  }

  ///Build list recent
  Widget _buildList() {
    if (_homePage?.list == null) {
      return Column(
        children: List.generate(8, (index) => index).map(
          (item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: AppProductItem(type: ProductViewType.small),
            );
          },
        ).toList(),
      );
    }

    return Column(
      children: _homePage.list.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Center(
            child: Container(
              width: 360.0,
              child: _DeliveryProcesses(processes: _data(1).deliveryProcesses),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: AppBarHomeSliver(
              expandedHeight: 250,
              banners: _homePage?.banner ?? [],
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  children: <Widget>[
                    // Container(
                    //   padding: EdgeInsets.only(
                    //     top: 10,
                    //     bottom: 15,
                    //     left: 10,
                    //     right: 10,
                    //   ),
                    //   child: _buildCategory(),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(
                    //     left: 20,
                    //     right: 20,
                    //   ),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Text(
                    //             Translate.of(context)
                    //                 .translate('popular_location'),
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .headline6
                    //                 .copyWith(fontWeight: FontWeight.w600),
                    //           ),
                    //           Padding(padding: EdgeInsets.only(top: 3)),
                    //           Text(
                    //             Translate.of(context)
                    //                 .translate('let_find_interesting'),
                    //             style: Theme.of(context).textTheme.bodyText1,
                    //           )
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   height: 195,
                    //   child: _buildPopular(),
                    // ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 15,
                      ),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Jadwal Presensi',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: _buildList(),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class _OrderTitle extends StatelessWidget {
  const _OrderTitle({
    Key key,
    @required this.orderInfo,
  })  : assert(orderInfo != null),
        super(key: key);

  final _OrderInfo orderInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Delivery #${orderInfo.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          '${orderInfo.date.day}/${orderInfo.date.month}/${orderInfo.date.year}',
          style: TextStyle(
            color: Color(0xffb6b2b2),
          ),
        ),
      ],
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    @required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key key, @required this.processes})
      : assert(processes != null),
        super(key: key);

  final List<_DeliveryProcess> processes;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              if (processes[index].isCompleted) return null;

              return Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 18.0,
                          ),
                    ),
                    _InnerTimeline(messages: processes[index].messages),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isCompleted) {
                return DotIndicator(
                  color: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              } else {
                return OutlinedDotIndicator(
                  borderWidth: 2.5,
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted
                  ? Theme.of(context).primaryColor
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

_OrderInfo _data(int id) => _OrderInfo(
      id: id,
      date: DateTime.now(),
      driverInfo: _DriverInfo(
        name: 'Philipe',
        thumbnailUrl:
            'https://i.pinimg.com/originals/08/45/81/084581e3155d339376bf1d0e17979dc6.jpg',
      ),
      deliveryProcesses: [
        _DeliveryProcess(
          'Package Process',
          messages: [
            _DeliveryMessage('8:30am', 'Package received by driver'),
            _DeliveryMessage('11:30am', 'Reached halfway mark'),
          ],
        ),
        _DeliveryProcess(
          'In Transit',
          messages: [
            _DeliveryMessage('13:00pm', 'Driver arrived at destination'),
            _DeliveryMessage('11:35am', 'Package delivered by m.vassiliades'),
          ],
        ),
        _DeliveryProcess.complete(),
      ],
    );

class _OrderInfo {
  const _OrderInfo({
    @required this.id,
    @required this.date,
    @required this.driverInfo,
    @required this.deliveryProcesses,
  });

  final int id;
  final DateTime date;
  final _DriverInfo driverInfo;
  final List<_DeliveryProcess> deliveryProcesses;
}

class _DriverInfo {
  const _DriverInfo({
    @required this.name,
    this.thumbnailUrl,
  });

  final String name;
  final String thumbnailUrl;
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.name, {
    this.messages = const [],
  });

  const _DeliveryProcess.complete()
      : this.name = 'Done',
        this.messages = const [];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}
