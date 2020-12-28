import 'dart:async';
import 'package:dio/dio.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SiappsRepository {
  ///Singleton factory
  static final SiappsRepository _instance = SiappsRepository._internal();

  /*
    * Ini adalah method static yang mengontrol akses ke singleton
    * instance. Saat pertama kali dijalankan, akan membuat objek tunggal dan menempatkannya
    * ke dalam array statis. Pada pemanggilan selanjutnya, ini mengembalikan klien yang ada
    * pada objek yang disimpan di array statis.
    *
    * Implementasi ini memungkinkan Anda membuat subclass kelas Singleton sambil mempertahankan
    * hanya satu instance dari setiap subclass sekitar.
    * @return SiappsRepository
    */
  factory SiappsRepository() {
    return _instance;
  }

  SiappsRepository._internal();

  Future getKuesioner() async {
    FormData formData = new FormData.fromMap({"tes": 'tes'});

    return Consumer().execute(url: '/jenis_opsi_jawabans', formData: formData);
  }

  Future<String> getToken() async {
    Application.preferences = await SharedPreferences.getInstance();

    String token = UtilPreferences.getToken()['refreshToken'];
    print('GET TOKEN');
    print(token);
    return UtilPreferences.getToken()['refreshToken'];
  }
}
