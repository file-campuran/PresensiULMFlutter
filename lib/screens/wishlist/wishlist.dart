import 'package:flutter/material.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WishList extends StatefulWidget {
  WishList({Key key}) : super(key: key);

  @override
  _WishListState createState() {
    return _WishListState();
  }
}

class _WishListState extends State<WishList> {
  final _controller = RefreshController(initialRefresh: false);
  WishListPageModel _listPage;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    final ResultApiModel result = await Api.getWishList();
    if (result.success) {
      setState(() {
        _listPage = new WishListPageModel.fromJson(result.data);
      });
    }
  }

  ///On load more
  Future<void> _onLoading() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.loadComplete();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.refreshCompleted();
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    String route = item.type == ProductType.place
        ? Routes.productDetail
        : Routes.productDetailTab;
    Navigator.pushNamed(context, route, arguments: item.id);
  }

  ///Build list
  Widget _buildList() {
    if (_listPage?.list == null) {
      return ListView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
        ),
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

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 15,
      ),
      itemCount: _listPage.list.length,
      itemBuilder: (context, index) {
        final item = _listPage.list[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: AppProductItem(
            onPressed: _onProductDetail,
            item: item,
            type: ProductViewType.small,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('wish_list')),
      ),
      body: SafeArea(
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
          child: _buildList(),
        ),
      ),
    );
  }
}
