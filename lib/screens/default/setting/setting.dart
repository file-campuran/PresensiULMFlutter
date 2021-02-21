import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/language.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() {
    return _SettingState();
  }
}

class _SettingState extends State<Setting> {
  bool _receiveNotification =
      UtilPreferences.containsKey(Preferences.notification);
  DarkOption _darkOption = AppTheme.darkThemeOption;
  ThemeBloc _themeBloc;

  @override
  void initState() {
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    super.initState();
  }

  ///On Change Dark Option
  void _onChangeDarkOption() {
    _themeBloc.add(ChangeTheme(darkOption: _darkOption));
  }

  ///On navigation
  void _onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  ///Show notification received
  Future<void> _showDarkModeSetting() async {
    return appMyInfoDialog(
        context: context,
        message: StatefulBuilder(
          builder: (BuildContext context, setState) => Column(
            children: <Widget>[
              CheckboxListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  Translate.of(context).translate(
                    UtilTheme.exportLangTheme(DarkOption.dynamic),
                  ),
                ),
                value: _darkOption == DarkOption.dynamic,
                onChanged: (bool value) {
                  setState(() {
                    _darkOption = DarkOption.dynamic;
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  Translate.of(context).translate(
                    UtilTheme.exportLangTheme(DarkOption.alwaysOn),
                  ),
                ),
                value: _darkOption == DarkOption.alwaysOn,
                onChanged: (bool value) {
                  setState(() {
                    _darkOption = DarkOption.alwaysOn;
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(
                  Translate.of(context).translate(
                    UtilTheme.exportLangTheme(DarkOption.alwaysOff),
                  ),
                ),
                value: _darkOption == DarkOption.alwaysOff,
                onChanged: (bool value) {
                  setState(() {
                    _darkOption = DarkOption.alwaysOff;
                  });
                },
              ),
            ],
          ),
        ),
        title: Translate.of(context).translate('dark_mode'),
        onTapText: Translate.of(context).translate('apply'),
        onTap: () {
          _onChangeDarkOption();
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomAppBar.defaultAppBar(
          title: Translate.of(context).translate('setting'), context: context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
          ),
          children: <Widget>[
            AppListTitle(
              icon: Icon(EvaIcons.bellOutline),
              title: Translate.of(context).translate('notification'),
              trailing: Switch(
                value: _receiveNotification,
                onChanged: (value) {
                  setState(() {
                    _receiveNotification = value;
                    if (value) {
                      UtilPreferences.setBool(Preferences.notification, true);
                    } else {
                      UtilPreferences.remove(Preferences.notification);
                    }
                  });
                },
              ),
            ),
            AppListTitle(
              icon: Icon(EvaIcons.globeOutline),
              title: Translate.of(context).translate('language'),
              onPressed: () {
                _onNavigate(Routes.changeLanguage);
              },
              trailing: Row(
                children: <Widget>[
                  Text(
                    UtilLanguage.getGlobalLanguageName(
                      AppLanguage.defaultLanguage.languageCode,
                    ),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  RotatedBox(
                    quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
            AppListTitle(
              icon: Icon(Icons.palette_outlined),
              title: Translate.of(context).translate('theme'),
              onPressed: () {
                _onNavigate(Routes.themeSetting);
              },
              trailing: Container(
                margin: EdgeInsets.only(right: 10),
                width: 16,
                height: 16,
                // color: Theme.of(context).primaryColor,
                child: Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            AppListTitle(
              icon: Icon(EvaIcons.moonOutline),
              title: Translate.of(context).translate('dark_mode'),
              onPressed: _showDarkModeSetting,
              trailing: Row(
                children: <Widget>[
                  Text(
                    Translate.of(context).translate(
                      UtilTheme.exportLangTheme(AppTheme.darkThemeOption),
                    ),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  RotatedBox(
                    quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
            AppListTitle(
              icon: Icon(EvaIcons.textOutline),
              title: Translate.of(context).translate('font'),
              onPressed: () {
                _onNavigate(Routes.fontSetting);
              },
              trailing: Row(
                children: <Widget>[
                  Text(
                    AppTheme.currentFont,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  RotatedBox(
                    quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
