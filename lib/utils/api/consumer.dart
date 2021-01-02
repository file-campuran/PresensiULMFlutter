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

  final String appId = 'PresensiULM';
  final String baseUrl = 'http://192.168.147.2/PTIK/api-siapps/public/api';
  final String apiKey = '605dafe39ee0780e8cf2c829434eeae8';
  final int timeout = 10; //Seconds

  int limits;
  Map<String, dynamic> orders;
  Map<String, dynamic> fillters;

  /*
   * Request ke API
   */
  Future<ApiModel> execute(
      {String url,
      FormData formData,
      String getData,
      MethodRequest method = MethodRequest.GET}) async {
    try {
      String urlRequest = url + generateQuery();

      // Application.preferences = await SharedPreferences.getInstance();
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

  /* 
   * Generate Query API
   */
  generateQuery() {
    String _tempOrder = '';
    String _tempFillter = '';

    orders?.forEach((key, value) {
      _tempOrder += '&$key=$value';
    });

    fillters?.forEach((key, value) {
      _tempFillter += _applyQueryFilter(key, value);
    });

    String _tempLimit = limits != null ? '&limit=$limits' : '';
    return '?' + _tempFillter + _tempOrder + _tempLimit;
  }

  /* 
   * Private Method Fillter Query
   */
  _applyQueryFilter(String key, String value) {
    final split = key.split(" ");
    final splitKey = split[0];

    String splitValue = split.length > 1 ? split[1] : '';
    switch (splitValue) {
      case '=':
        splitValue = '';
        break;
      case '>=':
        splitValue = '[gte]';
        break;
      case '<':
        splitValue = '[lt]';
        break;
      case '<=':
        splitValue = '[lte]';
        break;
      case '!=':
        splitValue = '[nq]';
        break;
      case 'is_null':
        splitValue = '[is_null]';
        break;
      case 'not_null':
        splitValue = '[not_null]';
        break;
      case 'in':
        splitValue = '[in]';
        break;
      case 'not_in':
        splitValue = '[not_in]';
        break;
      case 'like':
        splitValue = '[like]';
        break;
      case 'or_like':
        splitValue = '[or_like]';
        break;
      default:
        splitValue = '[eq]';
    }
    return "&$splitKey$splitValue=$value";
  }

  /* 
   * Limit data
   */
  limit(int limit) {
    this.limits = limit;
    return this;
  }

  /* 
   * Order Data
   */
  orderBy(Map<String, dynamic> order) {
    this.orders = order;
    return this;
  }

  /* 
   * Fillter Data
   */
  where(Map<String, dynamic> fillter) {
    this.fillters = fillter;
    return this;
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
