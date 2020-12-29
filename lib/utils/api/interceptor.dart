import 'dart:convert';
import 'package:absen_online/configs/application.dart';
import 'package:dio/dio.dart';
import 'consumer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';

class DioLoggingInterceptors extends InterceptorsWrapper {
  final Dio _dio;
  final bool withHeader = true;
  final bool withRefreshToken;
  // final JsonEncoder encoder = new JsonEncoder.withIndent('\t');

  DioLoggingInterceptors(this._dio, this.withRefreshToken);

  Future _refreshMethod(Response response) async {
    _dio.interceptors.requestLock.lock();
    _dio.interceptors.responseLock.lock();

    var token = await Consumer().refreshToken();
    String newAccessToken = token;

    // Break jika refresh token expired
    if (token == null) {
      return super.onResponse(response);
    }

    Application.preferences = await SharedPreferences.getInstance();
    UtilPreferences.setToken(
      accessToken: newAccessToken,
    );

    RequestOptions options = response.request;
    options.headers.addAll({'X-Token': newAccessToken});

    _dio.interceptors.requestLock.unlock();
    _dio.interceptors.responseLock.unlock();

    return _dio.request(options.path, options: options);
  }

  @override
  Future onRequest(RequestOptions options) async {
    print('\n');
    print(
        "┌ ${UtilLogger.color(" [ Begin Request ] ", ColorsHeader.PURPLE)} ───────────────────────────────────────────────────────────────────────");
    print(
        "| Method : ${UtilLogger.color(options.method != null ? options.method.toUpperCase() : 'METHOD', ColorsHeader.GREEN)}");
    print(
        "| URL : ${UtilLogger.color((options.baseUrl ?? "") + (options.path ?? ""), ColorsHeader.GREEN)}");

    _printHeader(options);

    if (options.queryParameters != null) {
      print("| queryParameters: ");
      options.queryParameters.forEach((k, v) => print('$k: $v'));
    }
    if (options.data != null) {
      print("| Body: ${options.data.toString()}");
    }

    print(
        "└——————————————————————————————————————————————————————————————————————————${UtilLogger.color(" End Request >>> ", ColorsHeader.PURPLE)}\n\n");

    return options;
  }

  @override
  Future onResponse(Response response) async {
    print('\n');
    print(
        "┌${UtilLogger.color(" [ Begin Response ] ", ColorsHeader.GREEN)} ────────────────────────────────────────────────────────────────────────");
    print(
        "| Status Code : ${UtilLogger.color(response.statusCode.toString(), ColorsHeader.GREEN)}");
    print(
        "| URL : ${UtilLogger.color(response.request != null ? (response.request.baseUrl + response.request.path) : 'URL', ColorsHeader.GREEN)}");
    // _printHeader(response);
    print(
        "|${UtilLogger.color("Response Message", ColorsHeader.YELLOW)} : \n ${UtilLogger.convert(response.data)}");
    print(
        "└——————————————————————————————————————————————————————————————————————————${UtilLogger.color(" End Response >>> ", ColorsHeader.GREEN)}\n\n");

    // if (withRefreshToken) {
    int statusCode = response.data['code'];

    if (statusCode == 401) {
      return _refreshMethod(response);
    } else {
      return super.onResponse(response);
    }
    // } else {
    //   return super.onResponse(response);
    // }
  }

  @override
  Future onError(DioError dioError) async {
    print('\n');
    print(
        "┌${UtilLogger.color(" [ Begin Error ] ", ColorsHeader.RED)}────────────────────────────────────────────────────────────────────────");
    print(
        "| Status Code : ${UtilLogger.color("${dioError.response?.statusCode}", ColorsHeader.RED)}");
    print(
        "| URL :  ${UtilLogger.color((dioError.response?.request != null ? (dioError.response.request.baseUrl + dioError.response.request.path) : 'URL'), ColorsHeader.RED)}");
    print("| Message : ${dioError.message}");
    print(
        "|${UtilLogger.color(" Response Message", ColorsHeader.YELLOW)} : \n ${UtilLogger.convert(dioError.response != null ? dioError.response.data : 'Unknown Error')}");
    print(
        "└——————————————————————————————————————————————————————————————————————————${UtilLogger.color(" End Eerror >>> ", ColorsHeader.RED)}\n\n");

    super.onError(dioError);
  }

  _printHeader(var response) {
    if (withHeader) {
      print("| Headers:");
      response.headers?.forEach((k, v) =>
          print(UtilLogger.color(" ├── $k: $v", ColorsHeader.PURPLE)));
      print("| \n");
    }
  }
}
