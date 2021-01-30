import 'package:absen_online/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:html/parser.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/configs/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Message extends StatefulWidget {
  Message({Key key}) : super(key: key);

  @override
  _MessageState createState() {
    return _MessageState();
  }
}

class _MessageState extends State<Message> {
  ScrollController _scrollController = ScrollController();
  List<MessageModel> listMessage = [];

  MessageCubit _messageCubit;

  @override
  void initState() {
    _messageCubit = BlocProvider.of<MessageCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(Translate.of(context).translate('message')),
          actions: <Widget>[
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text('Tandai sudah baca'),
                ),
                PopupMenuItem(
                  value: 0,
                  child: Text('Hapus'),
                ),
              ],
              // initialValue: 1,
              onCanceled: () {},
              onSelected: (value) async {
                if (value == 0) {
                  _messageCubit.markAll(value);
                } else {
                  _messageCubit.markAll(value);
                }
              },
              icon: Icon(Icons.more_horiz),
            ),
          ]),
      body: _buildContent(),
    );
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Card(
          margin: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          elevation: 0.2,
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 10.0, top: 5.0),
                    child: AppSkeleton(
                      width: 24.0,
                      height: 24.0,
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppSkeleton(
                          width: MediaQuery.of(context).size.width,
                          height: 20.0),
                      AppSkeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 20.0,
                            margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                            color: Colors.grey[300]),
                      ),
                      AppSkeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 20.0,
                            margin: EdgeInsets.only(bottom: 5.0),
                            color: Colors.grey[300]),
                      ),
                      AppSkeleton(
                          width: MediaQuery.of(context).size.width - 250,
                          height: 15.0),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _buildContent() {
    return BlocBuilder<MessageCubit, MessageState>(
      builder: (_, state) {
        if (state is MessageData) {
          return ListView.separated(
            controller: _scrollController,
            itemCount: state.data.length,
            separatorBuilder: (context, index) {
              return Container(
                  color: Theme.of(context).highlightColor, height: 1);
            },
            itemBuilder: (context, index) {
              bool hasRead = state.data[index].readAt == null ||
                      state.data[index].readAt == 0
                  ? false
                  : true;

              return GestureDetector(
                child: Container(
                  // color: Theme.of(context).dialogBackgroundColor,
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
                                child: Icon(Icons.message_rounded,
                                    color: Theme.of(context).primaryColor),
                              ),
                              hasRead
                                  ? Container()
                                  : Positioned(
                                      right: 0.0,
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                            ],
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              state.data[index].title,
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
                              _parseHtmlString(state.data[index].content),
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
                  AnalyticsHelper.setLogEvent(
                      Analytics.tappedMarkAsReadMessage);
                  if (state.data[index].readAt != 1) {
                    _messageCubit.markAsRead(state.data[index].id);
                  }
                  Navigator.of(context).pushNamed(Routes.messageDetail,
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
