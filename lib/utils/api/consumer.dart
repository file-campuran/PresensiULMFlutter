import 'package:absen_online/configs/config.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';
import 'exception.dart';
import 'interceptor.dart';

enum MethodRequest { GET, POST, PUT, DELETE }

class Consumer {
  ///Singleton factory
  static final Consumer _instance = Consumer._internal();

  /*
    * Ini adalah method static yang mengontrol akses ke singleton
    * instance. Saat pertama kali dijalankan, akan membuat objek tunggal dan menempatkannya
    * ke dalam array statis. Pada pemanggilan selanjutnya, ini mengembalikan klien yang ada
    * pada objek yang disimpan di array statis.
    *
    * Implementasi ini memungkinkan Anda membuat subclass kelas Singleton sambil mempertahankan
    * hanya satu instance dari setiap subclass sekitar.
    * @return Consumer
    */
  factory Consumer() {
    return _instance;
  }

  Consumer._internal();

  final String appId = 'SIAPPs';
  final String baseUrl = 'http://192.168.0.101/PTIK/api-siapps/public/api';
  final String apiKey = '605dafe39ee0780e8cf2c829434eeae8';
  final int timeout = 30; //Seconds

  /*
   * Request ke API
   */
  Future<ApiModel> execute(
      {String url,
      FormData formData,
      String getData,
      MethodRequest method = MethodRequest.GET}) async {
    try {
      String urlRequest = url;
      // urlRequest += getData ?? '';

      Application.preferences = await SharedPreferences.getInstance();
      BaseOptions options = new BaseOptions(
        headers: {
          'AppId': appId,
          'X-ApiKey': apiKey,
          'X-Token': UtilPreferences.getString('accessToken'),
        },
        baseUrl: baseUrl,
        method: this._convertMethod(method),
        connectTimeout: timeout * 1000,
        receiveTimeout: timeout * 1000,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      );

      Dio dio = new Dio(options);

      if (Application.debug) {
        dio.interceptors.add(DioLoggingInterceptors(dio, false));
      }

      Response<Map<String, dynamic>> res =
          await dio.request(urlRequest, data: formData);

      return ApiModel.fromJson(res.data);
    } on DioError catch (e) {
      return MyException.getException(e);
    }
  }

  /*
   * Autentikasi
   */
  Future<ApiModel> auth({String username, String password}) async {
    print(username);
    print(password);
    FormData formData =
        new FormData.fromMap({"username": username, 'password': password});

    return await this
        .execute(url: '/auth', formData: formData, method: MethodRequest.POST);
  }

  /*
   * Validate Refresh Token Jika masih berlaku
   */
  Future<ApiModel> validateToken(String token) async {
    FormData formData = new FormData.fromMap({"tokenRefresh": token});

    return await this.execute(
        url: '/auth/refresh', formData: formData, method: MethodRequest.PUT);
  }

  /*
   * Refresh token jika acces token expired
   */
  Future refreshToken() async {
    Application.preferences = await SharedPreferences.getInstance();

    FormData formData = new FormData.fromMap({
      "tokenRefresh": await UtilPreferences.getToken()['refreshToken'],
    });

    final response = await this.execute(
        url: '/auth/refresh', formData: formData, method: MethodRequest.PUT);

    if (response.code == CODE.SUCCESS) {
      return response.data['accessToken'];
    } else {
      return null;
    }
  }

  // Private convert method
  String _convertMethod(MethodRequest method) {
    switch (method) {
      case MethodRequest.POST:
        return 'POST';
        break;
      case MethodRequest.PUT:
        return 'PUT';
        break;
      case MethodRequest.DELETE:
        return 'DELETE';
        break;
      default:
        return 'GET';
    }
  }
}
