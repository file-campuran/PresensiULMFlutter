import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationList extends StatefulWidget {
  NotificationList({Key key}) : super(key: key);

  @override
  _NotificationListState createState() {
    return _NotificationListState();
  }
}

class _NotificationListState extends State<NotificationList> {
  final _controller = RefreshController(initialRefresh: false);

  NotificationBloc _notificationBloc;

  @override
  void initState() {
    // _loadData();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _notificationBloc.add(OnReadDataNotification());
    super.initState();
  }

  ///On load more
  Future<void> _onLoading() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.loadComplete();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    _notificationBloc.add(OnReadDataNotification());
    _controller.refreshCompleted();
  }

  ///Build list
  Widget _buildList() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationData) {
          //SHOW EMPTY DATA
          if (state.data.notification.length == 0) {
            return AppInfo(
              title: 'INFO',
              message: Translate.of(context).translate('there_is_no') +
                  ' ' +
                  Translate.of(context).translate('notification'),
              image: Images.Empty,
            );
          }

          //SHOW DATA
          return ListView.builder(
            padding: EdgeInsets.only(top: 5),
            itemCount: state.data.notification.length,
            itemBuilder: (context, index) {
              final item = state.data.notification[index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                child: AppNotificationItem(
                  item: item,
                  onPressed: () {
                    _notificationBloc.add(OnMarkReadNotification(item.id));
                    return appMyInfoDialog(
                      context: context,
                      message: item.content,
                      title: item.title,
                    );
                  },
                  border: false, //state.data.notification.length - 1 != index,
                ),
                background: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  color: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  _notificationBloc.add(OnRemoveNotification(item.id));
                },
              );
            },
          );
        }

        // SHOW LOADING SHIMMER
        return ListView(
          padding: EdgeInsets.only(top: 5),
          children: List.generate(8, (index) => index).map(
            (item) {
              return AppNotificationItem();
            },
          ).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomAppBar.defaultAppBar(
          title: Translate.of(context).translate('notification'),
          context: context),
      body: SafeArea(
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
          child: _buildList(),
        ),
      ),
      floatingActionButton: _appBadge(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _appBadge() {
    return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
      if (state is NotificationData) {
        if (state.data.count != 0) {
          return Align(
            alignment: FractionalOffset(0.5, 0.95),
            child: AppBadge(
              title: Translate.of(context).translate('mark_all_read'),
              onTap: () {
                _notificationBloc.add(OnMarkAllReadNotification());
              },
            ),
          );
        }
      }

      return Container();
    });
  }
}
