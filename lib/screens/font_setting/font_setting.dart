import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class FontSetting extends StatefulWidget {
  FontSetting({Key key}) : super(key: key);

  @override
  _FontSettingState createState() {
    return _FontSettingState();
  }
}

class _FontSettingState extends State<FontSetting> {
  ThemeBloc _themeBloc;
  String _currentFont = AppTheme.currentFont;

  @override
  void initState() {
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    super.initState();
  }

  ///On change Font
  void _onChange() async {
    _themeBloc.add(ChangeTheme(font: _currentFont));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('font'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                itemBuilder: (context, index) {
                  final item = AppTheme.fontSupport[index];
                  final trailing = item == _currentFont
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : null;
                  return AppListTitle(
                    title: item,
                    trailing: trailing,
                    onPressed: () {
                      setState(() {
                        _currentFont = item;
                      });
                    },
                    textStyle: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontFamily: item),
                  );
                },
                itemCount: AppTheme.fontSupport.length,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, theme) {
                  return AppButton(
                    onPressed: _onChange,
                    text: Translate.of(context).translate('apply'),
                    loading: theme is ThemeUpdating,
                    disableTouchWhenLoading: true,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
