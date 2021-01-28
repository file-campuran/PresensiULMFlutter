import 'dart:io';
import 'dart:typed_data';

// import 'package:esys_flutter_share/esys_flutter_share.dart' as fShare;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';

class MessageDetailScreen extends StatefulWidget {
  final MessageModel message;

  MessageDetailScreen({this.message});

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          centerTitle: true,
          title: Text(Translate.of(context).translate('message')),
        ),
        body: _buildContent(context, widget.message));
  }

  _loadingText() {
    List<Widget> widgets = [];

    for (int i = 0; i < 4; i++) {
      widgets.add(Container(
        margin: EdgeInsets.only(bottom: 5.0),
        width: MediaQuery.of(context).size.width,
        height: 18.0,
        color: Colors.grey,
      ));
    }

    widgets.add(Container(
      margin: EdgeInsets.only(bottom: 5.0),
      width: MediaQuery.of(context).size.width / 2,
      height: 18.0,
      color: Colors.grey,
    ));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  _buildContent(BuildContext context, MessageModel data) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        _buildText(
            Text(
              data.title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            context),
        _buildText(
            Text(
              data.humanDate(),
              style: TextStyle(fontSize: 15.0, color: Colors.grey),
            ),
            context),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 6, bottom: 10),
          child: Html(
              data: data.content,
              defaultTextStyle: TextStyle(
                fontSize: 15.0,
              ),
              customTextAlign: (dom.Node node) {
                return TextAlign.left;
              },
              onLinkTap: (url) {
                launchExternal(url);
              },
              customTextStyle: (dom.Node node, TextStyle baseStyle) {
                if (node is dom.Element) {
                  switch (node.localName) {
                    case "p":
                      return baseStyle.merge(TextStyle(height: 1.3));
                  }
                }
                return baseStyle;
              }),
        ),
        SizedBox(
          height: 10,
        ),
        // data.actionTitle != null && data.actionUrl != null
        //     ? RoundedButton(
        //         title: data.actionTitle,
        //         color: ColorBase.green,
        //         textStyle:
        //             TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //         onPressed: () {
        //           _launchUrl(data.actionUrl);
        //         })
        //     : Container()
      ],
    );
  }

  _buildText(Text text, context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 10.0),
      child: text,
    );
  }

  _bytesImageFromHtmlString(String htmlString) async {
    try {
      var document = parse(htmlString);
      String urlImage =
          document.getElementsByTagName('img')[0].attributes['src'];
      var request = await HttpClient().getUrl(Uri.parse(urlImage));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      return bytes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void dispose() {
    // _messageDetailBloc.close();
    super.dispose();
  }
}
