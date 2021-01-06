import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Faq extends StatefulWidget {
  Faq({Key key}) : super(key: key);

  @override
  _FaqState createState() {
    return _FaqState();
  }
}

class _FaqState extends State<Faq> {
  final _textLanguageController = TextEditingController();

  String search = '';

  @override
  void initState() {
    super.initState();
  }

  void _onFilter(String text) {
    setState(() {
      search = text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('faq');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Frequently Asked Question'),
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
              child: AppTextInput(
                hintText: Translate.of(context).translate('search'),
                icon: Icon(Icons.clear),
                controller: _textLanguageController,
                onChanged: _onFilter,
                onSubmitted: _onFilter,
                onTapIcon: () async {
                  await Future.delayed(Duration(milliseconds: 100));
                  _textLanguageController.clear();
                },
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, stream) {
                if (stream.connectionState == ConnectionState.waiting) {
                  return Center(child: AppColorLoader());
                }

                if (stream.hasError) {
                  return Center(child: Text(stream.error.toString()));
                }

                QuerySnapshot querySnapshot = stream.data;

                return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, index) =>
                        _cardContent(querySnapshot.docs[index].data())
                    // Text(querySnapshot.docs[index].data()['title']),
                    );
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget _cardContent(dataHelp) {
    String title = dataHelp['title'];
    String content = dataHelp['content'];

    if (search != '') {
      if (!title.toLowerCase().contains(search) &&
          !content.toLowerCase().contains(search)) {
        return Container();
      }
    }

    return Column(
      children: <Widget>[
        AppExpandableNotifier(
          child: ScrollOnExpand(
            scrollOnExpand: false,
            scrollOnCollapse: true,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  tapHeaderToExpand: true,
                  tapBodyToCollapse: true,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      dataHelp['title'],
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  expanded: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Html(
                      data: dataHelp['content'].replaceAll('\n', '</br>'),
                      defaultTextStyle:
                          TextStyle(color: Colors.grey[600], fontSize: 14.0),
                      onLinkTap: (url) {
                        print(url);
                        launchExternal(url);
                      },
                      customTextAlign: (dom.Node node) {
                        return TextAlign.left;
                      },
                    ),
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        crossFadePoint: 0,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          color: Colors.grey[300],
          height: 1,
        )
      ],
    );
  }
}
