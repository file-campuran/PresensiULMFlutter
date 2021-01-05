import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';
export 'package:absen_online/configs/config.dart';
import 'package:absen_online/api/http_manager.dart';

class PresensiRepository {
  static const PRIVACY_POLICY =
      'https://simari.ulm.ac.id/privacy_policy_presensi.html';
  static const GUIDE =
      'https://cdn01.ovo.id/homepage/public/assets/webview/panduan_ovo.html';

  ///Singleton factory
  static final PresensiRepository _instance = PresensiRepository._internal();

  factory PresensiRepository() {
    return _instance;
  }

  PresensiRepository._internal();

  // Ambil list / riwayat presensi
  Future<ApiModel> getPresensi() async {
    return await Consumer()
        .where({'user': '198112022014091002'})
        .orderBy({'absenTanggal': 'DESC'})
        .limit(10)
        .execute(url: '/absen');
  }

  // Simpan presensi
  Future<ApiModel> setPresensi(Map<String, dynamic> formDatas) async {
    UserModel _userModel = userModelFromJson(UtilPreferences.getString('user'));
    formDatas['user'] = _userModel.nip;

    FormData formData = new FormData.fromMap(formDatas);

    return await Consumer()
        .execute(url: '/absen', formData: formData, method: MethodRequest.POST);
  }

  // Ambil jadwal presensi
  Future<ApiModel> getJadwal() async {
    UserModel _userModel = userModelFromJson(UtilPreferences.getString('user'));
    return await Consumer().where({
      'role': _userModel.role,
      'user =': '198112022014091002'
    }).execute(url: '/absen/jadwal_presensi');
  }

  // Ubah Biodata, jika ada di database maka di ubah, jika tidak maka akan ditambahkan
  Future<ApiModel> setBiodata(
      {String alamat, String noPonsel, String golDarah}) async {
    FormData formData = new FormData.fromMap({
      "alamat": alamat,
      "noHp": noPonsel,
      "golDarah": golDarah,
    });

    UserModel _userModel = userModelFromJson(UtilPreferences.getString('user'));
    return Consumer().execute(
        url: '/biodata/' + _userModel.nip,
        formData: formData,
        method: MethodRequest.PUT);
  }

  static Future<String> getPrivacyPolicy() async {
    final result = await httpManager.get(url: PRIVACY_POLICY);
    return result;
  }

  // String getToken() {
  //   String token = UtilPreferences.getToken()['accessToken'];
  //   print('GET TOKEN');
  //   print(UtilLogger.convert(parseJwt(token)));
  //   return UtilPreferences.getToken()['refreshToken'];
  // }

  // Map<String, dynamic> getUser() {
  //   String token = UtilPreferences.getToken()['accessToken'];
  //   Map<String, dynamic> decode =
  //       json.decode(UtilLogger.convert(parseJwt(token)));

  //   return decode['user'];
  // }
}
