import 'package:flutter/material.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Review extends StatefulWidget {
  Review({Key key}) : super(key: key);

  @override
  _ReviewState createState() {
    return _ReviewState();
  }
}

class _ReviewState extends State<Review> {
  final _controller = RefreshController(initialRefresh: false);

  ReviewPageModel _reviewPage;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    final ResultApiModel result = await Api.getReview();
    if (result.success) {
      setState(() {
        _reviewPage = ReviewPageModel.fromJson(result.data);
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

  ///On navigate write review
  void _onWriteReview() {
    Navigator.pushNamed(
      context,
      Routes.writeReview,
      arguments: _reviewPage.author,
    );
  }

  ///Build list
  Widget _buildList() {
    if (_reviewPage?.comment == null) {
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
              child: AppCommentItem(),
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
      itemCount: _reviewPage.comment.length,
      itemBuilder: (context, index) {
        final item = _reviewPage.comment[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: AppCommentItem(item: item),
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
          Translate.of(context).translate('review'),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              Translate.of(context).translate('write'),
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
            onPressed: _onWriteReview,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              child: AppRating(
                rate: _reviewPage?.rate,
              ),
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                controller: _controller,
                header: ClassicHeader(
                  idleText:
                      Translate.of(context).translate('pull_down_refresh'),
                  refreshingText: Translate.of(context).translate('refreshing'),
                  completeText:
                      Translate.of(context).translate('refresh_completed'),
                  releaseText:
                      Translate.of(context).translate('release_to_refresh'),
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
                  idleText:
                      Translate.of(context).translate('pull_to_load_more'),
                  loadStyle: LoadStyle.ShowWhenLoading,
                  loadingIcon: SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                child: _buildList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
