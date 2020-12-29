import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class Update extends StatelessWidget {
  final String message;
  final String title;
  final String image;
  final bool isAndroid;
  final String linkAndroid;
  final String linkIos;
  final List news;

  const Update({
    Key key,
    @required this.message,
    this.image,
    this.title = '',
    this.isAndroid = true,
    this.linkIos,
    this.linkAndroid,
    this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children2 = <Widget>[
      Column(
        children: <Widget>[
          Center(
            child: SvgPicture.asset(
              'assets/svg/repair.svg',
              matchTextDirection: true,
              width: 200,
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      Padding(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Text(
          title,
          style: TextStyle(
              // fontFamily: Constants.DEFAULT_FONT,
              fontWeight: FontWeight.w700,
              fontSize: 20.5,
              color: Colors.grey[800]),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Padding(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Text(
          message,
          style: TextStyle(
              /* fontFamily: Constants.DEFAULT_FONT, */ color:
                  Colors.grey[800]),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 25,
      ),
      if (news.length != 0) ...[
        Padding(
          padding: EdgeInsets.only(left: 27, right: 27),
          child: Row(
            children: <Widget>[
              Text('Apa Yang Baru  '),
              Container(
                height: 10,
                width: 10,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle, color: Colors.green),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          // color: Colors.red,
          child: Padding(
            padding: EdgeInsets.only(left: 27, right: 27, bottom: 5),
            child: ListView(
              padding: EdgeInsets.only(top: 10),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: news
                      .map((item) => Text(
                            item,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
        ),
        Divider(),
      ],
      isAndroid
          ? InkWell(
              onTap: () {
                launch(linkAndroid);
              },
              child: Image(
                image: AssetImage('assets/images/google_play.png'),
                height: 30,
              ),
            )
          : InkWell(
              onTap: () {
                launch(linkIos);
              },
              child: Image(
                image: AssetImage('assets/images/app_store.png'),
                height: 30,
              ),
            ),
    ];

    return Scaffold(
      body: Container(
        // color: Colors.red,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children2,
        ),
      ),
    );
  }
}
