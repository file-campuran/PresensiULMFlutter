import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/utils/utils.dart';
import 'dart:io';

class Version extends StatelessWidget {
  const Version({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Scaffold(
      appBar: AppCustomAppBar.defaultAppBar(
          title: Translate.of(context).translate('version'), context: context),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Dimens.padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Images.Logo),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: Dimens.padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Environment.APP_NAME,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 25.5),
                        textAlign: TextAlign.center,
                      ),
                      Text(Environment.VERSION,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff10875F),
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(Dimens.padding),
            child: Row(
              children: [
                // Expanded(
                //   child: AppRoundedButton(
                //     title: Translate.of(context).translate('close'),
                //     textStyle:
                //         TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                //     borderSide:
                //         BorderSide(color: Theme.of(context).primaryColor),
                //     elevation: 0.0,
                //     color: Theme.of(context).scaffoldBackgroundColor,
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //     },
                //   ),
                // ),
                // SizedBox(width: Dimens.padding),
                Expanded(
                  child: AppRoundedButton(
                    title: Translate.of(context).translate('update'),
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    color: Theme.of(context).primaryColor,
                    elevation: 0.0,
                    onPressed: () {
                      launchExternal(Platform.isAndroid
                          ? Application.remoteConfig.update.androidUrl
                          : Application.remoteConfig.update.iosUrl);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: rootBundle.loadString("ChangeLog.md"),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                    data: snapshot.data,
                    controller: controller,
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
