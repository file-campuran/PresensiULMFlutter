import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
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

  NotificationPageModel _notificationPage;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    _notificationPage = AppNotification().loadNotification();
    AppNotification().getCount();

    setState(() {});
  }

  ///On load more
  Future<void> _onLoading() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.loadComplete();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    _loadData();
    _controller.refreshCompleted();
  }

  ///Build list
  Widget _buildList() {
    if (_notificationPage?.notification == null) {
      return ListView(
        padding: EdgeInsets.only(top: 5),
        children: List.generate(8, (index) => index).map(
          (item) {
            return AppNotificationItem();
          },
        ).toList(),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 5),
      itemCount: _notificationPage.notification.length,
      itemBuilder: (context, index) {
        final item = _notificationPage.notification[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          child: AppNotificationItem(
            item: item,
            onPressed: () {
              AppNotification().markAsRead(index);
              _loadData();
            },
            border: _notificationPage.notification.length - 1 != index,
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
            setState(() {
              AppNotification().removeNotif(index);
              _loadData();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          AppMyButton(
            icon: Icons.ac_unit,
            text: AppNotification().notification.count.toString(),
            loading: false,
            onPress: () {
              // AppNotification().notification.count++;
              AppNotification().addNotification('TITLE', 'MY MESSAGE');
              AppNotification().getCount();
              _loadData();
            },
          ),
        ],
        title: Text(
          Translate.of(context).translate('notification'),
        ),
      ),
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
    );
  }
}
