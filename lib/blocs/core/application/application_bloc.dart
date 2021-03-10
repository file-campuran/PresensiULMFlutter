import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final AuthBloc authBloc;
  final ThemeBloc themeBloc;
  final LanguageBloc languageBloc;
  final NotificationBloc notificationBloc;
  final MessageCubit messageCubit;

  ApplicationBloc({
    @required this.authBloc,
    @required this.themeBloc,
    @required this.languageBloc,
    @required this.notificationBloc,
    @required this.messageCubit,
  })  : assert(authBloc != null),
        super(InitialApplicationState());

  @override
  // ignore: override_on_non_overriding_member
  ApplicationState get initialState => InitialApplicationState();

  @override
  Stream<ApplicationState> mapEventToState(event) async* {
    if (event is SetupApplication) {
      ///Pending loading to UI
      yield ApplicationWaiting();

      ///Setup SharedPreferences
      Application.preferences = await SharedPreferences.getInstance();

      ///Setup Database SQFLITE
      Application.db = await DBProvider.db.database;

      ///Get old Theme & Font & Language
      final oldTheme = UtilPreferences.getString(Preferences.theme);
      final oldFont = UtilPreferences.getString(Preferences.font);
      final oldLanguage = UtilPreferences.getString(Preferences.language);
      final oldDarkOption = UtilPreferences.getString(Preferences.darkOption);

      ThemeModel theme;
      String font;
      DarkOption darkOption;

      ///Setup Language
      if (oldLanguage != null) {
        languageBloc.add(
          ChangeLanguage(Locale(oldLanguage)),
        );
      }

      ///Find font support available
      final fontAvailable = AppTheme.fontSupport.where((item) {
        return item == oldFont;
      }).toList();

      ///Find theme support available
      final themeAvailable = AppTheme.themeSupport.where((item) {
        return item.name == oldTheme;
      }).toList();

      ///Check theme and font available
      if (fontAvailable.isNotEmpty) {
        font = fontAvailable[0];
      }

      if (themeAvailable.isNotEmpty) {
        theme = themeAvailable[0];
      }

      ///check old dark option

      if (oldDarkOption != null) {
        switch (oldDarkOption) {
          case DARK_ALWAYS_OFF:
            darkOption = DarkOption.alwaysOff;
            break;
          case DARK_ALWAYS_ON:
            darkOption = DarkOption.alwaysOn;
            break;
          default:
            darkOption = DarkOption.dynamic;
        }
      }

      ///Setup Theme & Font with dark Option
      themeBloc.add(
        ChangeTheme(
          theme: theme ?? AppTheme.currentTheme,
          font: font ?? AppTheme.currentFont,
          darkOption: darkOption ?? AppTheme.darkThemeOption,
        ),
      );

      ///Authentication begin check
      authBloc.add(AuthenticationCheck());

      ///First or After upgrade version show intro preview app
      final hasReview = UtilPreferences.containsKey(
        '${Preferences.reviewIntro}.${Environment.VERSION}',
      );

      // Read Notification
      notificationBloc.add(OnReadDataNotification());
      messageCubit.readMessage();

      if (hasReview) {
        ///Become app
        // yield ApplicationSetupCompleted();
      } else {
        ///Pending preview intro
        yield ApplicationIntroView();
      }

      try {
        // Jika ada cache remote config
        if (UtilPreferences.containsKey(Preferences.remoteConfig)) {
          UtilLogger.log(
              'MY CONFIG', UtilPreferences.getString(Preferences.remoteConfig));
          final config = UtilPreferences.getString(Preferences.remoteConfig);
          Application.remoteConfig = ConfigModel.fromJson(config);
        } else {
          // Jika tidak ada gunakan config default aplikasi
          Application.remoteConfig =
              ConfigModel.fromJson(RemoteConfigs.defaultConfig);
        }

        // Set Evnironment data
        Environment.fromJson(Application.remoteConfig.environments.toJson());

        // Request Environment ke database
        RemoteConfig config = await FirebaseRemoteConfig.setupRemoteConfig();
        final remoteData = {
          "presensi": json.decode(config.getString('presensi')),
          "update": json.decode(config.getString('update')),
          "banner": json.decode(config.getString('banner')),
          "environments": json.decode(config.getString(
              Environment.DEBUG ? 'environments_dev' : 'environments')),
        };
        UtilLogger.log('ENVIRONMENT REMOTE USING',
            Environment.DEBUG ? 'environments_dev' : 'environments');

        UtilPreferences.setString(
            Preferences.remoteConfig, json.encode(remoteData));
        Application.remoteConfig = ConfigModel.fromJson(remoteData);

        if (hasReview) {
          ///Become app
          yield ApplicationSetupCompleted();
        }

        // Set Evnironment data
        Environment.fromJson(Application.remoteConfig.environments.toJson());

        UtilLogger.log('REMOTE CONFIG', Application.remoteConfig.toJson());
        // Cek Update Aplikasi
        if (Application.remoteConfig.update.minVersion >
            Environment.VERSION_CODE) {
          yield ApplicationUpdateView(Application.remoteConfig);
        }
      } catch (e) {
        if (hasReview) {
          ///Become app
          yield ApplicationSetupCompleted();
        }
        UtilPreferences.remove(Preferences.remoteConfig);
      }
    }

    ///Event Completed IntroView
    if (event is OnCompletedIntro) {
      await UtilPreferences.setBool(
        '${Preferences.reviewIntro}.${Environment.VERSION}',
        true,
      );
      await UtilPreferences.setBool(
        Preferences.notification,
        true,
      );

      ///Become app
      yield ApplicationSetupCompleted();
    }
  }

  void setEnvironment() {}
}
