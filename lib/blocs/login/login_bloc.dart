import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/blocs/authentication/bloc.dart';
import 'package:absen_online/blocs/login/bloc.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;

  LoginBloc({
    @required this.authBloc,
  }) : assert(authBloc != null);

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(event) async* {
    ///Event for login
    if (event is OnLogin) {
      ///Notify loading to UI
      yield LoginLoading();

      // await Future.delayed(Duration(seconds: 1));

      ///Fetch API
      final ApiModel result = await Consumer().auth(
        username: event.username,
        password: event.password,
      );

      ///Case API fail but not have token
      if (result.code == CODE.SUCCESS) {
        ///Login API success
        final parse = tokenFromJwt(result.data[Preferences.refreshToken]);
        UtilLogger.log(
            "PARSE JWT", parseJwt(result.data[Preferences.refreshToken]));
        final UserModel user = UserModel.fromJson({
          "id": 0,
          "full_name": parse.user.namaFakultas,
          "nickname": parse.user.namaFakultas,
          "photo": "Unknown",
          "url": "Unknown",
          "level": parse.user.namaFakultas,
          "description": parse.user.namaFakultas,
          "tag": parse.user.namaFakultas,
          "rate": 0.0,
          "token": "Unknown",
        });

        UtilPreferences.setString(
            Preferences.refreshToken, result.data[Preferences.refreshToken]);
        UtilPreferences.setString(
            Preferences.accessToken, result.data[Preferences.accessToken]);
        UtilPreferences.setString('user', user.toString());
        UtilLogger.log('USER', user.toString());

        try {
          ///Begin start AuthBloc Event AuthenticationSave
          authBloc.add(AuthenticationSave(user));

          ///Notify loading to UI
          yield LoginSuccess();
        } catch (error) {
          ///Notify loading to UI
          yield LoginFail(error.toString());
        }
      } else {
        ///Notify loading to UI
        yield LoginFail(result.message);
      }
    }

    ///Event for logout
    if (event is OnLogout) {
      yield LogoutLoading();
      try {
        ///Begin start AuthBloc Event OnProcessLogout
        authBloc.add(AuthenticationClear());

        ///Notify loading to UI
        yield LogoutSuccess();
      } catch (error) {
        ///Notify loading to UI
        yield LogoutFail(error.toString());
      }
    }
  }
}
