import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/language.dart';
import 'package:absen_online/utils/other.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class LanguageSetting extends StatefulWidget {
  LanguageSetting({Key key}) : super(key: key);

  @override
  _LanguageSettingState createState() {
    return _LanguageSettingState();
  }
}

class _LanguageSettingState extends State<LanguageSetting> {
  LanguageBloc _languageBloc;
  final _textLanguageController = TextEditingController();
  bool _loading = false;

  List<Locale> _listLanguage = AppLanguage.supportLanguage;
  Locale _languageSelected = AppLanguage.defaultLanguage;

  @override
  void initState() {
    _languageBloc = BlocProvider.of<LanguageBloc>(context);
    super.initState();
  }

  ///On filter language
  void _onFilter(String text) {
    if (text.isEmpty) {
      setState(() {
        _listLanguage = AppLanguage.supportLanguage;
      });
      return;
    }
    setState(() {
      _listLanguage = _listLanguage.where(((item) {
        return UtilLanguage.getGlobalLanguageName(item.languageCode)
            .toUpperCase()
            .contains(text.toUpperCase());
      })).toList();
    });
  }

  ///On change language
  Future<void> _changeLanguage() async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _loading = true;
    });
    _languageBloc.add(
      ChangeLanguage(_languageSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('change_language')),
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
              child: ListView.builder(
                padding: EdgeInsets.only(left: 20, right: 20),
                itemBuilder: (context, index) {
                  final item = _listLanguage[index];
                  final trailing = item == _languageSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : null;
                  return AppListTitle(
                    title: UtilLanguage.getGlobalLanguageName(
                      item.languageCode,
                    ),
                    textStyle: item == _languageSelected
                        ? Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: Theme.of(context).primaryColor)
                        : null,
                    trailing: trailing,
                    onPressed: () {
                      setState(() {
                        _languageSelected = item;
                      });
                    },
                  );
                },
                itemCount: _listLanguage.length,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              child: BlocListener<LanguageBloc, LanguageState>(
                listener: (context, state) {
                  if (state is LanguageUpdated) {
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                child: AppButton(
                  onPressed: () {
                    _changeLanguage();
                  },
                  text: Translate.of(context).translate('confirm'),
                  loading: _loading,
                  disableTouchWhenLoading: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
