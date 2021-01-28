import 'dart:async';

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

  ApplicationBloc({
    @required this.authBloc,
    @required this.themeBloc,
    @required this.languageBloc,
    @required this.notificationBloc,
  })  : assert(authBloc != null),
        super(InitialApplicationState());

  @override
  ApplicationState get initialState => InitialApplicationState();

  @override
  Stream<ApplicationState> mapEventToState(event) async* {
    if (event is SetupApplication) {
      ///Pending loading to UI
      yield ApplicationWaiting();

      ///Setup SharedPreferences
      UtilLogger.log('INITIALIZE SHARED PREF');
      Application.preferences = await SharedPreferences.getInstance();

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

      if (hasReview) {
        ///Become app
        yield ApplicationSetupCompleted();
      } else {
        ///Pending preview intro
        yield ApplicationIntroView();
      }

      if (UtilPreferences.containsKey(Preferences.remoteConfig)) {
        final config = UtilPreferences.getString(Preferences.remoteConfig);
        Application.remoteConfig = configModelFromJson(config);
      }

      RemoteConfig config = await FirebaseRemoteConfig.setupRemoteConfig();
      UtilPreferences.setString(
          Preferences.remoteConfig, config.getString('config'));
      Application.remoteConfig =
          configModelFromJson(config.getString('config'));
      UtilLogger.log('REMOTE CONFIG', Application.remoteConfig.toJson());

      // Cek Update Aplikasi
      if (Application.remoteConfig.application.minVersion >
          Environment.VERSION_CODE) {
        yield ApplicationUpdateView(Application.remoteConfig);
      }
    }

    ///Event Completed IntroView
    if (event is OnCompletedIntro) {
      await UtilPreferences.setBool(
        '${Preferences.reviewIntro}.${Environment.VERSION}',
        true,
      );

      ///Become app
      yield ApplicationSetupCompleted();
    }
  }
}
