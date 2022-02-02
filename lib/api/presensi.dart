import 'dart:async';
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
        .execute(url: '/presensi/absen');
  }

  Future<ApiModel> getEvent() async {
    return await Consumer()
        .limit(20)
        .orderBy({'tanggal': 'DESC'}).execute(url: '/presensi/event');
  }

  Future<ApiModel> getLokasiPresensi() async {
    return await Consumer().limit(-1).execute(url: '/presensi/lokasiPresensi');
  }

  Future<ApiModel> getPengaturanPresensi() async {
    return await Consumer().limit(-1).execute(url: '/presensi/pengaturan');
  }

  Future<ApiModel> getKecamatan() async {
    return await Consumer()
        .limit(-1)
        .execute(url: '/presensi/kecamatan?isValid[eq]=1');
  }

  Future<ApiModel> getHariKerja() async {
    return await Consumer().limit(7).execute(url: '/presensi/hari_libur');
  }

  Future<ApiModel> getPengumuman({String startDate = null}) async {
    if (startDate != null) {
      return await Consumer()
          .where({'tgl >': startDate}).execute(url: '/presensi/pengumuman');
    }

    return await Consumer().execute(url: '/presensi/pengumuman');
  }

  // Simpan presensi
  Future<ApiModel> setPresensi(Map<String, dynamic> formDatas) async {
    UserModel _userModel =
        userModelFromJson(UtilPreferences.getString(Preferences.user));
    formDatas['user'] = _userModel.nip;

    FormData formData = new FormData.fromMap(formDatas);

    return await Consumer().execute(
        url: '/presensi/absen', formData: formData, method: MethodRequest.POST);
  }

  // Detail presensi
  Future<ApiModel> getDetailPresensi() async {
    UserModel _userModel =
        userModelFromJson(UtilPreferences.getString(Preferences.user));

    return await Consumer()
        .where({'user': _userModel.nip, 'role': _userModel.role}).execute(
            url: '/presensi/absen/detail', method: MethodRequest.GET);
  }

  // Ambil jadwal presensi
  Future<ApiModel> getJadwal() async {
    UserModel _userModel =
        userModelFromJson(UtilPreferences.getString(Preferences.user));
    return await Consumer()
        .where({'role': _userModel.role, 'user': _userModel.nip}).execute(
            url: '/presensi/absen/jadwal_presensi');
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
        url: '/presensi/biodata/' + _userModel.nip,
        formData: formData,
        method: MethodRequest.PUT);
  }

  // Ambil data biodata
  Future<ApiModel> getBiodata(String nip) async {
    return Consumer().where({'username': nip}).execute(
        url: '/presensi/biodata', method: MethodRequest.GET);
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
          url: '/presensi/firebase_token',
          formData: formData,
          method: MethodRequest.PUT);
    }
  }

  static Future<String> getPrivacyPolicy() async {
    final result = await httpManager.get(url: Environment.privacyPolicy);
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

  //   return decode[Preferences.user];
  // }
}
