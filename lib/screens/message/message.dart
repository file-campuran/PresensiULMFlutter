import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/configs/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    initFaq();
    super.initState();
  }

  void initFaq() {
    FirebaseFirestore.instance
        .collection('message')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        listMessage.add(MessageModel.fromJson(element.data()));
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Query query = FirebaseFirestore.instance.collection('faq');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Message'),
      ),
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
                        child: Container(
                            width: MediaQuery.of(context).size.width - 170,
                            height: 20.0,
                            margin: EdgeInsets.only(bottom: 15.0),
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
    return listMessage.isNotEmpty
        ? ListView.separated(
            controller: _scrollController,
            itemCount: listMessage.length,
            separatorBuilder: (context, index) {
              return Container(
                  color: Theme.of(context).highlightColor, height: 10);
            },
            itemBuilder: (context, index) {
              bool hasRead = listMessage[index].readAt == null ||
                      listMessage[index].readAt == 0
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
                                child: Image.asset(
                                  Images.Broadcast,
                                  width: 32.0,
                                  height: 32.0,
                                ),
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
                              listMessage[index].title,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                              child: Text(
                                listMessage[index].publishedAt.toString(),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                            ),
                            Text(
                              _parseHtmlString(listMessage[index].content),
                              maxLines: 3,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.messageDetail,
                      arguments: listMessage[index]);
                },
              );
            },
          )
        : _buildLoading();
  }
}
