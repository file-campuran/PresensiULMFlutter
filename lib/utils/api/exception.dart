import 'dart:io';
import 'package:dio/dio.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';

const String ErrorInternalTitle = 'Error Internal Server';
const String ErrorApplicationTitle = 'Application Error';
const String ErrorFormat = 'Format Exception';
const String ErrorHttp = 'Network Error';
const String Error404 = 'Page Not Found';
const String Error500 = 'Internal Server Error';
const String Error401 = 'Redirect';
const String ErrorSocket = 'Can\'t connect to server\n';

const String Warning = 'assets/svg/warning.svg';

class MyException {
  static ApiModel getException(DioError e) {
    UtilLogger.log('EXCEPTION ERROR', e.error.runtimeType);
    switch (e.error.runtimeType) {
      case SocketException:
        {
          return ApiModel.fromJson({
            'code': 500,
            "message": <String, dynamic>{
              'title': ErrorApplicationTitle,
              'content': ErrorSocket + e.message,
              "image": Warning
            },
          });
        }
        break;

      case FormatException:
        {
          return ApiModel.fromJson({
            'code': 500,
            "message": <String, dynamic>{
              'title': ErrorApplicationTitle,
              'content': ErrorFormat,
              "image": Warning
            },
          });
        }
        break;

      case HttpException:
        {
          return ApiModel.fromJson({
            'code': 500,
            "message": <String, dynamic>{
              'title': ErrorApplicationTitle,
              'content': ErrorHttp,
              "image": Warning
            },
          });
        }
        break;

      default:
        {
          if (e.response == null) {
            return ApiModel.fromJson({
              'code': 500,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': e.message.toString(),
                "image": Warning
              },
            });
          } else if (e.response.statusCode == 500) {
            return ApiModel.fromJson({
              'code': 500,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': e.response.data['message'],
                "image": Warning
              },
            });
          } else if (e.response.statusCode == 401) {
            return ApiModel.fromJson({
              'code': 401,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': Error401,
                "image": Warning
              },
            });
          } else if (e.response.statusCode == 404) {
            return ApiModel.fromJson({
              'code': 404,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': Error404,
                "image": Warning
              },
            });
          } else if (e.response != null) {
            return ApiModel.fromJson({
              'code': 500,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': e.response.data['error'],
                "image": Warning
              },
            });
          } else {
            return ApiModel.fromJson({
              'code': 500,
              "message": <String, dynamic>{
                'title': ErrorInternalTitle,
                'content': e.message.toString(),
                "image": Warning
              },
            });
          }
        }
        break;
    }
  }
}
