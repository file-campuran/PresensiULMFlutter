import 'package:absen_online/configs/config.dart';
import 'package:dio/dio.dart';
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

  final int timeout = Environment.apiTimeout; //Seconds

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
          'AppId': Environment.apiId,
          'X-ApiKey': Environment.apiKey,
          'X-Token': UtilPreferences.getString(Preferences.accessToken),
        },
        baseUrl: Environment.apiUrl,
        method: this._convertMethod(method),
        connectTimeout: timeout * 1000,
        receiveTimeout: timeout * 1000,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      );

      Dio dio = new Dio(options);

      dio.interceptors.add(DioLoggingInterceptors(dio, false));

      this._cleanFillter();
      Response<Map<String, dynamic>> res =
          await dio.request(urlRequest, data: formData);

      ApiModel apiModel = ApiModel.fromJson(res.data);

      if (apiModel.code == CODE.ERROR) {
        return ApiModel.fromJson({
          'code': 500,
          "message": <String, dynamic>{
            'title': ErrorApplicationTitle,
            'content': apiModel.message,
            "image": Warning
          },
        });
      }

      return apiModel;
    } on DioError catch (e) {
      final exception = MyException.getException(e);
      UtilLogger.log('EXCEPTION DIO', exception.toJson());
      return exception;
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
    this._cleanFillter();
    FormData formData = new FormData.fromMap({
      "tokenRefresh": UtilPreferences.getString(Preferences.refreshToken),
    });

    final response = await this.execute(
        url: '/auth/refresh', formData: formData, method: MethodRequest.PUT);

    if (response.code == CODE.SUCCESS) {
      return response.data['accessToken'];
    } else {
      return null;
    }
  }

  _cleanFillter() {
    this.fillters = {};
    this.orders = {};
    this.limits = null;
    return this;
  }

  /* 
   * Generate Query API
   */
  generateQuery() {
    String _tempOrder = '';
    String _tempFillter = '';

    orders?.forEach((key, value) {
      _tempOrder += '&$key[sort]=$value';
    });

    fillters?.forEach((key, value) {
      _tempFillter += _applyQueryFilter(key, value);
    });

    String _tempLimit = limits != null ? '&limit=$limits' : '';

    String _combineFillter = _tempFillter + _tempOrder + _tempLimit;
    _combineFillter =
        _combineFillter.length != 0 ? _combineFillter.substring(1) : '';
    return _combineFillter != '' ? '?' + _combineFillter : '';
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
      case '>':
        splitValue = '[gt]';
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
