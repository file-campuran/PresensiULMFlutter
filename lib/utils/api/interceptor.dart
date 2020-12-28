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
  final JsonEncoder encoder = new JsonEncoder.withIndent('\t');

  DioLoggingInterceptors(this._dio, this.withRefreshToken);

  Future refreshMethod(Response response) async {
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
        "┌ ${_changeColor(" [ Begin Request ] ", ColorsHeader.PURPLE)} ───────────────────────────────────────────────────────────────────────");
    print(
        "| Method : ${_changeColor(options.method != null ? options.method.toUpperCase() : 'METHOD', ColorsHeader.GREEN)}");
    print(
        "| URL : ${_changeColor((options.baseUrl ?? "") + (options.path ?? ""), ColorsHeader.GREEN)}");

    _printHeader(options);

    if (options.queryParameters != null) {
      print("| queryParameters: ");
      options.queryParameters.forEach((k, v) => print('$k: $v'));
    }
    if (options.data != null) {
      print("| Body: ${options.data.toString()}");
    }

    print(
        "└——————————————————————————————————————————————————————————————————————————${_changeColor(" End Request >>> ", ColorsHeader.PURPLE)}\n\n");

    return options;
  }

  @override
  Future onResponse(Response response) async {
    print('\n');
    print(
        "┌${_changeColor(" [ Begin Response ] ", ColorsHeader.GREEN)} ────────────────────────────────────────────────────────────────────────");
    print(
        "| Status Code : ${_changeColor(response.statusCode.toString(), ColorsHeader.GREEN)}");
    print(
        "| URL : ${_changeColor(response.request != null ? (response.request.baseUrl + response.request.path) : 'URL', ColorsHeader.GREEN)}");
    // _printHeader(response);
    print(
        "|${_changeColor("Response Message", ColorsHeader.YELLOW)} : \n ${encoder.convert(response.data)}");
    print(
        "└——————————————————————————————————————————————————————————————————————————${_changeColor(" End Response >>> ", ColorsHeader.GREEN)}\n\n");

    // if (withRefreshToken) {
    int statusCode = response.data['code'];

    if (statusCode == 401) {
      return refreshMethod(response);
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
        "┌${_changeColor(" [ Begin Error ] ", ColorsHeader.RED)}────────────────────────────────────────────────────────────────────────");
    print(
        "| Status Code : ${_changeColor("${dioError.response?.statusCode}", ColorsHeader.RED)}");
    print(
        "| URL :  ${_changeColor((dioError.response?.request != null ? (dioError.response.request.baseUrl + dioError.response.request.path) : 'URL'), ColorsHeader.RED)}");
    print("| Message : ${dioError.message}");
    print(
        "|${_changeColor(" Response Message", ColorsHeader.YELLOW)} : \n ${encoder.convert(dioError.response != null ? dioError.response.data : 'Unknown Error')}");
    print(
        "└——————————————————————————————————————————————————————————————————————————${_changeColor(" End Eerror >>> ", ColorsHeader.RED)}\n\n");

    super.onError(dioError);
  }

  _printHeader(var response) {
    if (withHeader) {
      print("| Headers:");
      response.headers?.forEach(
          (k, v) => print(_changeColor(" ├── $k: $v", ColorsHeader.PURPLE)));
      print("| \n");
    }
  }

  // Private convert method
  String _changeColor(String text, ColorsHeader colors) {
    switch (colors) {
      case ColorsHeader.RED:
        return "\x1b[31m $text \x1b[0m";
        break;

      case ColorsHeader.PURPLE:
        return "\x1b[35m $text \x1b[0m";
        break;

      case ColorsHeader.GREEN:
        return "\x1b[32m $text \x1b[0m";
        break;

      case ColorsHeader.YELLOW:
        return "\x1b[33m $text \x1b[0m";
        break;

      default:
        return text;
    }
  }
}

enum ColorsHeader { RED, GREEN, PURPLE, YELLOW, DEFAULT }
