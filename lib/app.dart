import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/main_navigation.dart';
import 'package:absen_online/screens/screen.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Routes route = Routes();

  ApplicationBloc _applicationBloc;
  LanguageBloc _languageBloc;
  ThemeBloc _themeBloc;
  AuthBloc _authBloc;
  LoginBloc _loginBloc;
  NotificationBloc _notificationBloc;
  MessageCubit _messageCubit;

  JadwalCubit _jadwalCubit;

  @override
  void initState() {
    ///Bloc business logic
    _notificationBloc = NotificationBloc();
    _languageBloc = LanguageBloc();
    _themeBloc = ThemeBloc();
    _authBloc = AuthBloc();
    _messageCubit = MessageCubit();
    _loginBloc = LoginBloc(authBloc: _authBloc);
    _applicationBloc = ApplicationBloc(
      authBloc: _authBloc,
      themeBloc: _themeBloc,
      languageBloc: _languageBloc,
      notificationBloc: _notificationBloc,
      messageCubit: _messageCubit,
    );

    _jadwalCubit = JadwalCubit();
    super.initState();
  }

  @override
  void dispose() {
    _applicationBloc.close();
    _languageBloc.close();
    _themeBloc.close();
    _authBloc.close();
    _loginBloc.close();
    _notificationBloc.close();
    _messageCubit.close();
    _jadwalCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).primaryColorBrightness));
    return MultiBlocProvider(
      providers: [
        BlocProvider<ApplicationBloc>(
          create: (context) => _applicationBloc,
        ),
        BlocProvider<LanguageBloc>(
          create: (context) => _languageBloc,
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => _themeBloc,
        ),
        BlocProvider<AuthBloc>(
          create: (context) => _authBloc,
        ),
        BlocProvider<LoginBloc>(
          create: (context) => _loginBloc,
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => _notificationBloc,
        ),
        BlocProvider<MessageCubit>(
          create: (context) => _messageCubit,
        ),
        BlocProvider<JadwalCubit>(
          create: (context) => _jadwalCubit,
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, lang) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, theme) {
              return MaterialApp(
                color: Colors.white,
                title: Environment.APP_NAME,
                debugShowCheckedModeBanner: Environment.DEBUG,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                onGenerateRoute: route.generateRoute,
                locale: AppLanguage.defaultLanguage,
                localizationsDelegates: [
                  Translate.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: AppLanguage.supportLanguage,
                home: BlocBuilder<ApplicationBloc, ApplicationState>(
                  builder: (context, app) {
                    if (app is ApplicationSetupCompleted) {
                      return BlocBuilder<AuthBloc, AuthenticationState>(
                        builder: (context, auth) {
                          if (auth is AuthenticationFail) {
                            return Login();
                          } else if (auth is AuthenticationSuccess) {
                            return MainNavigation();
                          }
                          return Container();
                        },
                      );
                    }
                    if (app is ApplicationIntroView) {
                      return IntroPreview();
                    }

                    if (app is ApplicationUpdateView) {
                      return Update(
                        message:
                            'Aplikasi membutuhkan pembaharuan ke versi ${app.config.update.releaseVersion}',
                        title: 'Pembaharuan',
                        isAndroid: Platform.isAndroid,
                        linkIos: app.config.update.iosUrl,
                        linkAndroid: app.config.update.androidUrl,
                        news: app.config.update.news,
                      );
                    }

                    return SplashScreen();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
