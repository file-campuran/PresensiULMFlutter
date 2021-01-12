import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/api/http_manager.dart';

class PresensiRepository {
  ///Singleton factory
  static final PresensiRepository _instance = PresensiRepository._internal();

  factory PresensiRepository() {
    return _instance;
  }

  PresensiRepository._internal();

  // Ambil list / riwayat presensi
  Future<ApiModel> getPresensi() async {
    UserModel _userModel =
        userModelFromJson(UtilPreferences.getString(Preferences.user));

    return await Consumer()
        .where({'user': _userModel.nip})
        .orderBy({'absenTanggal': 'DESC'})
        .limit(10)
        .execute(url: '/absen');
  }

  // Simpan presensi
  Future<ApiModel> setPresensi(Map<String, dynamic> formDatas) async {
    UserModel _userModel =
        userModelFromJson(UtilPreferences.getString(Preferences.user));
    formDatas['user'] = _userModel.nip;

    FormData formData = new FormData.fromMap(formDatas);

    return await Consumer()
        .execute(url: '/absen', formData: formData, method: MethodRequest.POST);
  }

  // Detail presensi
  Future<ApiModel> getDetailPresensi() async {
    UserModel _userModel =
        userModelFromJson(UtilPreferences.getString(Preferences.user));

    return await Consumer()
        .where({'user': _userModel.nip, 'role': _userModel.role}).execute(
            url: '/absen/detail', method: MethodRequest.GET);
  }

  // Ambil jadwal presensi
  Future<ApiModel> getJadwal() async {
    getToken();
    UserModel _userModel =
        userModelFromJson(UtilPreferences.getString(Preferences.user));
    return await Consumer()
        .where({'role': _userModel.role, 'user': _userModel.nip}).execute(
            url: '/absen/jadwal_presensi');
  }

  // Ubah Biodata, jika ada di database maka di ubah, jika tidak maka akan ditambahkan
  Future<ApiModel> setBiodata(
      {String alamat, String noPonsel, String golDarah}) async {
    FormData formData = new FormData.fromMap({
      "alamat": alamat,
      "noHp": noPonsel,
      "golDarah": golDarah,
    });

    UserModel _userModel =
        userModelFromJson(UtilPreferences.getString(Preferences.user));
    return Consumer().execute(
        url: '/biodata/' + _userModel.nip,
        formData: formData,
        method: MethodRequest.PUT);
  }

  // Ambil data biodata
  Future<ApiModel> getBiodata(String nip) async {
    return Consumer().where({'username': nip}).execute(
        url: '/biodata', method: MethodRequest.GET);
  }

  static setFirebaseToken() {
    if (UtilPreferences.getString(Preferences.user) != null) {
      UserModel _userModel =
          userModelFromJson(UtilPreferences.getString(Preferences.user));
      FormData formData = new FormData.fromMap({
        "token": Application.pushToken,
        "role": _userModel.role,
        "nip": _userModel.nip,
      });
      Consumer().execute(
          url: '/firebase_token',
          formData: formData,
          method: MethodRequest.PUT);
    }
  }

  static Future<String> getPrivacyPolicy() async {
    final result = await httpManager.get(url: Environment.PRIVACY_POLICY);
    return result;
  }

  String getToken() {
    String token = UtilPreferences.getToken()['accessToken'];
    print('GET TOKEN');
    print(UtilLogger.convert(parseJwt(token)));
    return UtilPreferences.getToken()['refreshToken'];
  }

  Map<String, dynamic> getUser() {
    String token = UtilPreferences.getToken()['accessToken'];
    Map<String, dynamic> decode =
        json.decode(UtilLogger.convert(parseJwt(token)));

    return decode[Preferences.user];
  }
}
