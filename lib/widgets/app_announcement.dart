import 'package:absen_online/utils/services/translate.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/rich_text_parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:absen_online/configs/config.dart';
import 'package:html/parser.dart';

class AppAnnouncement extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final BuildContext context;
  final Function onTap;
  final Function onNext;
  final String actionUrl;
  final TextStyle textStyleTitle;
  final TextStyle textStyleContent;
  final TextStyle textStyleMoreDetail;

  AppAnnouncement(
      {this.title,
      this.content,
      this.date,
      this.context,
      this.onTap,
      this.onNext,
      this.actionUrl,
      this.textStyleTitle,
      this.textStyleContent,
      this.textStyleMoreDetail});

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          color: Color(0xffFFF3CC), borderRadius: BorderRadius.circular(8.0)),
      child: Material(
        color: Color(0xffFFF3CC),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onNext,
          child: Stack(
            children: <Widget>[
              Image.asset(Images.Intersect, width: 73),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: textStyleTitle != null
                                  ? textStyleTitle
                                  : TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              date,
                              textAlign: TextAlign.end,
                              style: textStyleTitle != null
                                  ? textStyleTitle
                                  : TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w200),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      ///Set Text content & url if actionUrl is not empty
                      Text(
                        _parseHtmlString(content),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: onTap,
                            child: Text(
                              Translate.of(context).translate('more'),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
