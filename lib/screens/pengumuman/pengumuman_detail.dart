import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class PengumumanDetailScreen extends StatefulWidget {
  final PengumumanModel message;

  PengumumanDetailScreen({this.message});

  @override
  _PengumumanDetailScreenState createState() => _PengumumanDetailScreenState();
}

class _PengumumanDetailScreenState extends State<PengumumanDetailScreen> {
  ScrollController _scrollController = ScrollController();
  String title = '';
  double elavation = 0;
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  _scrollListener() {
    // UtilLogger.log('SCROLL POSITION', _scrollController.offset);

    if (_scrollController.offset > 60) {
      // UtilLogger.log('SHOW');
      if (title == '') {
        setState(() {
          elavation = 0.5;
          title = widget.message.judul;
        });
      }
    } else if (title != '') {
      // UtilLogger.log('HIDE');
      setState(() {
        elavation = 0;
        title = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppCustomAppBar.defaultAppBar(
            elavation: elavation,
            leading: BackButton(),
            title: title,
            context: context),
        body: _buildContent(context, widget.message));
  }

  _buildContent(BuildContext context, PengumumanModel data) {
    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.all(10),
      children: <Widget>[
        _buildText(
            Text(
              data.judul,
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
              data: data.konten,
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

  // _bytesImageFromHtmlString(String htmlString) async {
  //   try {
  //     var document = parse(htmlString);
  //     String urlImage =
  //         document.getElementsByTagName('img')[0].attributes['src'];
  //     var request = await HttpClient().getUrl(Uri.parse(urlImage));
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     return bytes;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  @override
  void dispose() {
    // _messageDetailBloc.close();
    super.dispose();
  }
}
