import 'package:absen_online/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/configs/config.dart';
import 'package:flutter_svg/svg.dart';

void appMyInfoDialog({
  @required BuildContext context,
  String title,
  dynamic message,
  String image,
  Function onTap,
  String onTapText = 'understand',
  String onCloseText = 'close',
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    // backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
    ),
    isDismissible: false,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.symmetric(vertical: 10, horizontal: Dimens.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Theme.of(context).highlightColor),
              ),
              if (image != null) ...[
                SizedBox(height: Dimens.padding),
                Center(
                  child: SvgPicture.asset(
                    image ?? Images.Warning,
                    matchTextDirection: true,
                    width: 200,
                  ),
                ),
              ],
              SizedBox(height: Dimens.padding + 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? 'Respon Server',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Dimens.padding),
                  _buildWidget(message),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppRoundedButton(
                      title: Translate.of(context).translate(onCloseText),
                      textStyle: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      elevation: 0.0,
                      color: Theme.of(context).canvasColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  if (onTap != null) ...[
                    SizedBox(width: Dimens.padding),
                    Expanded(
                      child: AppRoundedButton(
                        title: Translate.of(context).translate(onTapText),
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        color: Theme.of(context).primaryColor,
                        elevation: 0.0,
                        onPressed: onTap,
                      ),
                    )
                  ],
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );

  // return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title ?? 'Respon Server'),
  //         content: SingleChildScrollView(
  //           child: _buildWidget(message),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Close'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     });
}

Widget _buildWidget(dynamic message) {
  UtilLogger.log('MESSAGE', message);
  List<String> error = [];
  if (message is Map) {
    message.forEach((k, v) => error.add('$v'));
  }

  if (message is Widget) {
    return message;
  } else if (message is String) {
    return AppTextList(message, withIndicator: false);
  } else if (message['content'] != null) {
    return AppTextList(
      message['content'],
      withIndicator: true,
    );
    // return AppInfo(
    //     message: message['content'],
    //     title: message['title'],
    //     image: Images.Warning);
  }

  return ListBody(
    children: error
        .map(
          (e) => AppTextList(e),
        )
        .toList(),
  );
}
