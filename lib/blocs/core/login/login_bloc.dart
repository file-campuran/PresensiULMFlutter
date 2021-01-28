import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/blocs/core/authentication/bloc.dart';
import 'bloc.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;

  LoginBloc({
    @required this.authBloc,
  })  : assert(authBloc != null),
        super(InitialLoginState());

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(event) async* {
    ///Event for login
    if (event is OnLogin) {
      ///Notify loading to UI
      yield LoginLoading();

      ///Fetch API
      final ApiModel auth = await Consumer().auth(
        username: event.username,
        password: event.password,
      );

      try {
        ///Case API fail but not have token
        if (auth.code == CODE.SUCCESS) {
          ///Login API success
          final parse = tokenFromJwt(auth.data[Preferences.refreshToken]);
          UtilLogger.log("PARSE JWT", parse.toJson());
          UtilPreferences.setString(
              Preferences.refreshToken, auth.data[Preferences.refreshToken]);
          UtilPreferences.setString(
              Preferences.accessToken, auth.data[Preferences.accessToken]);

          ApiModel biodata =
              await PresensiRepository().getBiodata(parse.user.username);

          if (biodata.code == CODE.SUCCESS) {
            biodata.data['role'] = parse.user.role;
            final UserModel user = UserModel.fromJson(biodata.data);
            Application.user = user;
            UtilPreferences.setString(Preferences.user, user.toString());

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
            yield LoginFail(biodata.message is String
                ? biodata.message
                : biodata.message['content']);
          }
        } else {
          ///Notify loading to UI
          yield LoginFail(
              auth.message is Map ? auth.message['content'] : auth.message);
        }
      } catch (e) {
        yield LoginFail(e.toString());
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
