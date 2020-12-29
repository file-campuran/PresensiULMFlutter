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
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Center(
            child: Container(
              width: 360.0,
              child: _DeliveryProcesses(
                processes: [
                  _DeliveryProcess(
                    'Pagi Mulai',
                    messages: [
                      _DeliveryMessage('8:30am', 'Package received by driver'),
                      _DeliveryMessage('11:30am', 'Reached halfway mark'),
                      _DeliveryMessage('11:30am', 'Reached halfway mark'),
                    ],
                  ),
                  _DeliveryProcess(
                    'Selesai ',
                    messages: [
                      _DeliveryMessage(
                          '13:00pm', 'Driver arrived at destination'),
                      _DeliveryMessage(
                          '11:35am', 'Package delivered by m.vassiliades'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
              // if (processes[index].isCompleted) return null;

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
                    AppProductItem(type: ProductViewType.cardSmall),
                    Text('12')
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              return DotIndicator(
                color: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: 12.0,
                ),
              );
              // if (processes[index].isCompleted) {
              // } else {
              //   return OutlinedDotIndicator(
              //     borderWidth: 2.5,
              //   );
              // }
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
