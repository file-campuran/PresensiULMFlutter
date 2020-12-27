import 'package:flutter/material.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';

import 'search_result_list.dart';
import 'search_suggest_list.dart';

class SearchHistory extends StatefulWidget {
  SearchHistory({Key key}) : super(key: key);

  @override
  _SearchHistoryState createState() {
    return _SearchHistoryState();
  }
}

class _SearchHistoryState extends State<SearchHistory> {
  SearchHistoryPageModel _historyPage;
  SearchHistorySearchDelegate _delegate = SearchHistorySearchDelegate();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    setState(() {
      _historyPage = null;
    });
    final ResultApiModel result = await Api.getHistorySearch();
    if (result.success) {
      setState(() {
        _historyPage = SearchHistoryPageModel.fromJson(result.data);
        _delegate = SearchHistorySearchDelegate();
      });
    }
  }

  Future<ProductModel> _onSearch() async {
    final ProductModel selected = await showSearch(
      context: context,
      delegate: _delegate,
    );
    return selected;
  }

  ///On navigate list product
  void _onProductList(TagModel item) {
    Navigator.pushNamed(
      context,
      Routes.listProduct,
      arguments: item.title,
    );
  }

  ///Build list tag
  List<Widget> _listTag(BuildContext context) {
    if (_historyPage?.tag == null) {
      return List.generate(6, (index) => index).map(
        (item) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).dividerColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child: AppTag(
              Translate.of(context).translate('loading'),
              type: TagType.gray,
            ),
          );
        },
      ).toList();
    }

    return _historyPage.tag.map((item) {
      return InputChip(
        onPressed: () {
          _onProductList(item);
        },
        label: Text(item.title),
        onDeleted: () {
          _historyPage.tag.remove(item);
          setState(() {});
        },
      );
    }).toList();
  }

  ///Build list discover
  List<Widget> _listDiscover(BuildContext context) {
    if (_historyPage?.discover == null) {
      return List.generate(6, (index) => index).map(
        (item) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).dividerColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child: AppTag(
              Translate.of(context).translate('loading'),
              type: TagType.gray,
            ),
          );
        },
      ).toList();
    }

    return _historyPage.discover.map((item) {
      return InputChip(
        onPressed: () {
          _onProductList(item);
        },
        label: Text(item.title),
        onDeleted: () {
          _historyPage.discover.remove(item);
          setState(() {});
        },
      );
    }).toList();
  }

  ///Build popular
  List<Widget> _listPopular() {
    if (_historyPage?.popular == null) {
      return List.generate(8, (index) => index).map(
        (item) {
          return Padding(
            padding: EdgeInsets.only(right: 15),
            child: SizedBox(
              width: 100,
              height: 100,
              child: AppProductItem(
                type: ProductViewType.cardSmall,
              ),
            ),
          );
        },
      ).toList();
    }

    return _historyPage.popular.map(
      (item) {
        return Padding(
          padding: EdgeInsets.only(right: 15),
          child: SizedBox(
            width: 100,
            height: 100,
            child: AppProductItem(
              item: item,
              type: ProductViewType.cardSmall,
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _delegate?.transitionAnimation,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(Translate.of(context).translate('search_title')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearch,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Translate.of(context)
                            .translate('search_history')
                            .toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          _historyPage.tag.clear();
                          setState(() {});
                        },
                        child: Text(
                          Translate.of(context).translate('clear'),
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: Theme.of(context).accentColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    children: _listTag(context),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Translate.of(context)
                            .translate('discover_more')
                            .toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          _historyPage.discover.clear();
                          setState(() {});
                        },
                        child: Text(
                          Translate.of(context).translate('clear'),
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: Theme.of(context).accentColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    children: _listDiscover(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Translate.of(context)
                        .translate('recently_viewed')
                        .toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
              child: ListView(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 5,
                ),
                scrollDirection: Axis.horizontal,
                children: _listPopular(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchHistorySearchDelegate extends SearchDelegate<ProductModel> {
  SearchHistorySearchDelegate();

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    if (isDark) {
      return theme;
    }

    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SuggestionList(query: query);
  }

  @override
  Widget buildResults(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return ResultList(query: query, statusBarHeight: statusBarHeight);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
      ];
    }
    return null;
  }
}
