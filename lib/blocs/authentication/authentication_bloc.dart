import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/blocs/authentication/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(event) async* {
    if (event is AuthenticationCheck) {
      ///Notify state AuthenticationBeginCheck
      yield AuthenticationBeginCheck();
      final hasToken = UtilPreferences.containsKey(Preferences.refreshToken);

      if (hasToken) {
        yield AuthenticationSuccess();

        // //Getting data from Storage
        // final getUserPreferences = UtilPreferences.getString(
        //   Preferences.refreshToken,
        // );

        // // Cek refresh token apakah masih valid
        // final result = await Consumer().validateToken(getUserPreferences);

        // ///Fetch api success
        // if (result.code == CODE.SUCCESS) {
        //   ///Set user
        //   UtilPreferences.setString(
        //       Preferences.accessToken, result.data[Preferences.accessToken]);
        //   yield AuthenticationSuccess();
        // } else {
        //   ///Fetch api fail
        //   ///Delete user when can't verify token
        //   await UtilPreferences.remove(Preferences.user);

        //   ///Notify loading to UI
        //   yield AuthenticationFail();
        // }
      } else {
        ///Notify loading to UI
        yield AuthenticationFail();
      }
      // }
    }

    if (event is AuthenticationSave) {
      ///Save to Storage phone
      final savePreferences = await UtilPreferences.setString(
        Preferences.user,
        jsonEncode(event.user.toJson()),
      );

      ///Check result save user
      if (savePreferences) {
        ///Notify loading to UI
        yield AuthenticationSuccess();
      } else {
        final String message = "Cannot save user data to storage phone";
        throw Exception(message);
      }
    }

    if (event is AuthenticationClear) {
      ///Delete user
      final deletePreferences =
          await UtilPreferences.remove(Preferences.refreshToken);
      await UtilPreferences.remove(Preferences.accessToken);

      ///Check result delete user
      if (deletePreferences) {
        yield AuthenticationFail();
      } else {
        final String message = "Cannot delete user data to storage phone";
        throw Exception(message);
      }
    }
  }
}
