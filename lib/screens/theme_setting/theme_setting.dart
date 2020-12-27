import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class ThemeSetting extends StatefulWidget {
  ThemeSetting({Key key}) : super(key: key);

  @override
  _ThemeSettingState createState() {
    return _ThemeSettingState();
  }
}

class _ThemeSettingState extends State<ThemeSetting> {
  ThemeBloc _themeBloc;
  ThemeModel _currentTheme = AppTheme.currentTheme;

  @override
  void initState() {
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    super.initState();
  }

  ///On Change Theme
  void _onChange() {
    _themeBloc.add(ChangeTheme(theme: _currentTheme));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('theme'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                itemBuilder: (context, index) {
                  final item = AppTheme.themeSupport[index];
                  final selected = item.name == _currentTheme.name;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _currentTheme = item;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 24,
                                  height: 24,
                                  color: item.color,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),
                                Text(
                                  Translate.of(context).translate(item.name),
                                  style: Theme.of(context).textTheme.subtitle2,
                                )
                              ],
                            ),
                            selected
                                ? Icon(
                                    Icons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: AppTheme.themeSupport.length,
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
