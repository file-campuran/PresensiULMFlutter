import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/configs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:absen_online/configs/config.dart';
import 'package:absen_online/api/http_manager.dart';

class PresensiRepository {
  ///Singleton factory
  static final PresensiRepository _instance = PresensiRepository._internal();

  factory PresensiRepository() {
    return _instance;
  }

  PresensiRepository._internal();

  Future<ApiModel> getPresensi() async {
    return await Consumer()
        .where({'user': '198112022014091002'})
        .orderBy({'absenTanggal': 'DESC'})
        .limit(10)
        .execute(url: '/absen');
  }

  Future<ApiModel> setPresensi(Map<String, dynamic> formDatas) async {
    FormData formData = new FormData.fromMap(formDatas);
    print(formDatas);

    return await Consumer()
        .execute(url: '/absen', formData: formData, method: MethodRequest.POST);
  }

  Future<ApiModel> getJadwal() async {
    return await Consumer().where({
      'role': 'tenaga_kependidikan',
      'user =': '198112022014091002'
    }).execute(url: '/absen/jadwal_presensi');
  }

  Future<ApiModel> setBiodata(
      {String alamat, String noPonsel, String golDarah}) async {
    FormData formData = new FormData.fromMap({
      "alamat": alamat,
      "noPonsel": noPonsel,
      "golDarah": golDarah,
    });

    return Consumer().execute(
        url: '/jenis_opsi_jawaban',
        formData: formData,
        method: MethodRequest.POST);
  }

  static Future<String> getPrivacyPolicy() async {
    final result = await httpManager.get(url: '/privacy_policy_presensi.html');
    return result;
  }

  static String getPanduanUrl() {
    return 'https://cdn01.ovo.id/homepage/public/assets/webview/panduan_ovo.html';
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

    return decode['user'];
  }
}
