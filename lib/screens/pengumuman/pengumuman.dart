import 'package:absen_online/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:html/parser.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/configs/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Pengumuman extends StatefulWidget {
  Pengumuman({Key key}) : super(key: key);

  @override
  _PengumumanState createState() {
    return _PengumumanState();
  }
}

class _PengumumanState extends State<Pengumuman> {
  ScrollController _scrollController = ScrollController();
  List<PengumumanModel> listPengumuman = [];

  PengumumanCubit _pengumumanCubit;
  bool showMarkAll = true;
  final _controller = RefreshController(initialRefresh: false);

  @override
  void initState() {
    _pengumumanCubit = BlocProvider.of<PengumumanCubit>(context);
    _pengumumanCubit.readMessage();
    super.initState();
  }

  ///On load more
  Future<void> _onLoading() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomAppBar.defaultAppBar(
        title: Translate.of(context).translate('announcement'),
        context: context,
        actions: Environment.DEBUG
            ? <Widget>[
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text('Hapus'),
                    ),
                  ],
                  // initialValue: 1,
                  onCanceled: () {},
                  onSelected: (value) async {
                    if (value == 0) {
                      _pengumumanCubit.markAll(value);
                    } else {
                      _pengumumanCubit.markAll(value);
                    }
                  },
                  icon: Icon(Icons.more_horiz),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: _onRefresh,
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
          child: _buildContent(),
        ),
      ),
      floatingActionButton: _appBadge(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _onRefresh() async {
    _pengumumanCubit.loadData();
    _controller.refreshCompleted();
  }

  Widget _appBadge() {
    return BlocBuilder<PengumumanCubit, PengumumanState>(
        builder: (context, state) {
      if (state is PengumumanData) {
        if (state.count != 0) {
          return Align(
            alignment: FractionalOffset(0.5, 0.95),
            child: AppBadge(
              title: Translate.of(context).translate('mark_all_read'),
              onTap: () {
                _pengumumanCubit.markAll(1);
              },
            ),
          );
        }
      }

      return Container();
    });
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Container(
          margin: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppSkeleton(
                  child: Container(
                    margin: EdgeInsets.only(right: 10.0, top: 0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).highlightColor,
                    ),
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppSkeleton(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).highlightColor,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 20.0,
                          margin: EdgeInsets.only(bottom: 5.0),
                        ),
                      ),
                      AppSkeleton(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).highlightColor,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 20.0,
                          margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                        ),
                      ),
                      AppSkeleton(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).highlightColor,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 20.0,
                          margin: EdgeInsets.only(bottom: 5.0),
                        ),
                      ),
                      AppSkeleton(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).highlightColor,
                          ),
                          width: MediaQuery.of(context).size.width - 250,
                          height: 15.0,
                          margin: EdgeInsets.only(bottom: 5.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _buildContent() {
    return BlocBuilder<PengumumanCubit, PengumumanState>(
      builder: (_, state) {
        if (state is PengumumanData) {
          if (state.data.length == 0) {
            return AppInfo(
              title: 'INFO',
              message: Translate.of(context).translate('there_is_no') +
                  ' ' +
                  Translate.of(context).translate('announcement'),
              image: Images.Empty,
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              bool hasRead = state.data[index].isRead == null ||
                      state.data[index].isRead == 0
                  ? false
                  : true;

              return InkWell(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(top: hasRead ? 0.0 : 2.0),
                                child: Icon(
                                    hasRead
                                        ? EvaIcons.messageCircleOutline
                                        : EvaIcons.messageCircle,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              state.data[index].judul,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: hasRead ? Colors.grey : null),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                              child: Text(
                                state.data[index].humanDate(),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                            ),
                            Text(
                              _parseHtmlString(state.data[index].konten),
                              maxLines: 3,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: hasRead ? Colors.grey : null),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (state.data[index].isRead != 1) {
                    _pengumumanCubit.markAsRead(state.data[index].id);
                  }
                  Navigator.pushNamed(context, Routes.pengumumanDetail,
                      arguments: state.data[index]);
                },
              );
            },
          );
        }

        return _buildLoading();
      },
    );
  }
}
