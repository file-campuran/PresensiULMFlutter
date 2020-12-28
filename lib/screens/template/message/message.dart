import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/message_page_model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/app_message_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageList extends StatefulWidget {
  MessageList({Key key}) : super(key: key);

  @override
  _MessageListState createState() {
    return _MessageListState();
  }
}

class _MessageListState extends State<MessageList> {
  final _controller = RefreshController(initialRefresh: false);
  final SlidableController _slideController = SlidableController();

  MessagePageModel _messagePage;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    final ResultApiModel result = await Api.getMessage();
    if (result.success) {
      setState(() {
        _messagePage = MessagePageModel.fromJson(result.data);
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

  ///On navigate chat screen
  void _onChat(MessageModel item) {
    Navigator.pushNamed(context, Routes.chat, arguments: item.id);
  }

  ///Build list
  Widget _buildList() {
    if (_messagePage?.message == null) {
      return ListView(
        padding: EdgeInsets.only(top: 5),
        children: List.generate(8, (index) => index).map(
          (item) {
            return AppMessageItem();
          },
        ).toList(),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 5),
      itemCount: _messagePage.message.length,
      itemBuilder: (context, index) {
        final item = _messagePage.message[index];
        return Slidable(
          controller: _slideController,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: AppMessageItem(
            item: item,
            onPressed: () {
              _onChat(item);
            },
            border: _messagePage.message.length - 1 != index,
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: Translate.of(context).translate('more'),
              color: Theme.of(context).dividerColor,
              icon: Icons.more_horiz,
              onTap: () => {},
            ),
            IconSlideAction(
              caption: Translate.of(context).translate('delete'),
              color: Theme.of(context).accentColor,
              icon: Icons.delete,
              onTap: () => {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('message'),
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
