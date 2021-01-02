import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'MyButton.dart';

class Error extends StatelessWidget {
  final String message;
  final String image;
  final ViewMode mode;
  final String title;

  final Function onPress;
  final bool btnRefresh;
  final bool btnRefreshLoading;

  const Error(
      {Key key,
      @required this.message,
      this.image,
      this.mode = ViewMode.Asset,
      this.title = 'Oops.., terjadi kesalahan',
      this.btnRefresh = false,
      this.btnRefreshLoading = false,
      this.onPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlankPage(
      message: message,
      image: image,
      isLoading: false,
      mode: mode,
      title: title,
      btnRefresh: true,
      btnRefreshLoading: btnRefreshLoading,
      onPress: onPress,
    );
  }
}

class Info extends StatelessWidget {
  final String message;
  final String title;
  final String image;
  final ViewMode mode;

  const Info(
      {Key key,
      @required this.message,
      this.image,
      this.mode = ViewMode.Asset,
      this.title = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlankPage(
      message: message,
      image: image,
      isLoading: false,
      mode: mode,
      title: title,
    );
  }
}

class Loading extends StatelessWidget {
  final String message;
  const Loading({Key key, @required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlankPage(
      message: '',
      isLoading: true,
      image: 'assets/lottie/loading.json',
      mode: ViewMode.Lottie,
    );
  }
}

enum ViewMode { Lottie, Network, Asset, Svg }

class BlankPage extends StatelessWidget {
  final String message;
  final String title;
  final bool isLoading;
  final Function onPress;
  final bool btnRefresh;
  final bool btnRefreshLoading;
  final String image;
  final ViewMode mode;
  const BlankPage(
      {Key key,
      @required this.message,
      this.image,
      this.isLoading,
      this.mode,
      this.btnRefresh = false,
      this.btnRefreshLoading = false,
      this.title = '',
      this.onPress})
      : super(key: key);

  Widget modes(BuildContext context) {
    String modes = image?.split("/")?.last;
    modes = modes?.split(".")?.last;

    print(modes);
    if (modes == 'json') {
      return Center(
        child: Lottie.asset(
          "$image",
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      );
    } else if (modes == 'svg') {
      return Column(
        children: <Widget>[
          Center(
            child: SvgPicture.asset(
              image,
              matchTextDirection: true,
              width: 200,
            ),
          ),
          SizedBox(height: 40),
        ],
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.height * 0.4,
        decoration:
            BoxDecoration(image: DecorationImage(image: AssetImage(image))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('BLANK PAGE');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      // color: Colors.red,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image != null ? modes(context) : Container(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Text(
              title,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.5,
                  ),
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
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          btnRefresh
              ? MyButton(
                  loading: btnRefreshLoading,
                  text: 'Reload',
                  icon: Icons.refresh,
                  onPress: onPress,
                )
              : Container(),
        ],
      ),
    );
  }
}
