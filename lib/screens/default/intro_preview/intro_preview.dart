import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';

class IntroPreview extends StatefulWidget {
  IntroPreview({Key key}) : super(key: key);

  @override
  _IntroPreviewState createState() {
    return _IntroPreviewState();
  }
}

class _IntroPreviewState extends State<IntroPreview> {
  ApplicationBloc _applicationBloc;

  @override
  void initState() {
    _applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    super.initState();
  }

  ///On complete preview intro
  void _onCompleted() {
    _applicationBloc.add(OnCompletedIntro());
  }

  @override
  Widget build(BuildContext context) {
    ///List Intro view page model
    final List<PageViewModel> pages = [
      PageViewModel(
        pageColor: Colors.red[400],
        bubble: Icon(
          Icons.shop,
          color: Colors.white,
        ),
        body: Text(
          Translate.of(context).translate('slide1_content'),
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.white,
              ),
        ),
        title: Text(
          Translate.of(context).translate('slide1_title'),
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.white),
        ),
        titleTextStyle: Theme.of(context).textTheme.headline4,
        bodyTextStyle: Theme.of(context).textTheme.headline6,
        mainImage: Image.asset(
          Images.Intro1,
          fit: BoxFit.contain,
        ),
      ),
      PageViewModel(
        pageColor: Colors.orange[400],
        bubble: Icon(
          Icons.phonelink,
          color: Colors.white,
        ),
        body: Text(
          Translate.of(context).translate('slide2_content'),
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        title: Text(
          Translate.of(context).translate('slide2_title'),
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.white),
        ),
        titleTextStyle: Theme.of(context).textTheme.headline4,
        bodyTextStyle: Theme.of(context).textTheme.headline6,
        mainImage: Image.asset(
          Images.Intro3,
          fit: BoxFit.contain,
        ),
      ),
      PageViewModel(
        pageColor: Colors.grey[400],
        bubble: Icon(
          Icons.home,
          color: Colors.white,
        ),
        body: Text(
          Translate.of(context).translate('slide3_content'),
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        title: Text(
          Translate.of(context).translate('slide3_title'),
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(color: Colors.white),
        ),
        titleTextStyle: Theme.of(context).textTheme.headline4,
        bodyTextStyle: Theme.of(context).textTheme.headline6,
        mainImage: Image.asset(
          Images.Intro2,
          fit: BoxFit.contain,
        ),
      ),
    ];

    ///Build Page
    return Scaffold(
      body: IntroViewsFlutter(
        pages,
        onTapSkipButton: _onCompleted,
        onTapDoneButton: _onCompleted,
        pageButtonTextStyles:
            Theme.of(context).textTheme.button.copyWith(color: Colors.white),
      ),
    );
  }
}
