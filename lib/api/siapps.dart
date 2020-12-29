import 'dart:async';
import 'package:dio/dio.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/configs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SiappsRepository {
  ///Singleton factory
  static final SiappsRepository _instance = SiappsRepository._internal();

  factory SiappsRepository() {
    return _instance;
  }

  SiappsRepository._internal();

  Future<ApiModel> getKuesioner() async {
    FormData formData = new FormData.fromMap({"tes": 'tes'});

    return Consumer().execute(url: '/jenis_opsi_jawaban', formData: formData);
  }

  Future<ApiModel> getPresensi() async {
    return await Consumer().execute(url: '/absen?limit=10');
  }

  Future<String> getToken() async {
    Application.preferences = await SharedPreferences.getInstance();

    String token = UtilPreferences.getToken()['accessToken'];
    print('GET TOKEN');
    print(UtilLogger.convert(parseJwt(token)));
    return UtilPreferences.getToken()['refreshToken'];
  }
}
