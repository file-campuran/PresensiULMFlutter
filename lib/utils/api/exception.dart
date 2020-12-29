import 'dart:io';
import 'package:dio/dio.dart';
import 'package:absen_online/models/model.dart';

class MyException {
  static ApiModel getException(DioError e) {
    // switch (e.type) {
    //   case DioErrorType.RESPONSE:
    //     return e.response?.data['message'] ?? 'Unknown error';

    //   case DioErrorType.SEND_TIMEOUT:
    //   case DioErrorType.RECEIVE_TIMEOUT:
    //     return "request_time_out";

    //   default:
    // }

    switch (e.error.runtimeType) {
      case SocketException:
        {
          return ApiModel.fromJson({
            'code': 500,
            'message': 'Dictionary.socketException',
            "image": "assets/images/undraw/warning.svg"
          });
        }
        break;

      case FormatException:
        {
          return ApiModel.fromJson({
            'code': 500,
            'message': 'Dictionary.formatException',
          });
        }
        break;

      case HttpException:
        {
          return ApiModel.fromJson({
            'code': 500,
            'message': 'Dictionary.httpException',
            "image": "assets/images/undraw/warning.svg"
          });
        }
        break;

      default:
        {
          if (e.response == null) {
            return ApiModel.fromJson({
              'code': 500,
              'message': e.message.toString(),
              "image": "assets/images/undraw/warning.svg"
            });
          } else if (e.response.statusCode == 500) {
            return ApiModel.fromJson({
              'code': 500,
              "message": "Dictionary.errorInternal",
              "image": "assets/images/undraw/warning.svg"
            });
          } else if (e.response.statusCode == 401) {
            return ApiModel.fromJson({
              'code': 401,
              "message": "${e.response.data['error']}",
              "image": "assets/images/undraw/dream.svg"
            });
          } else if (e.response.statusCode == 404) {
            return ApiModel.fromJson({
              'code': 404,
              "message": "Dictionary.errorNotFound",
              "image": "assets/images/undraw/dream.svg"
            });
          }

          if (e.response != null) {
            return ApiModel.fromJson({
              'code': 500,
              "message": e.response.data['error'],
              "image": "assets/images/undraw/dream.svg"
            });
          } else {
            return ApiModel.fromJson({
              'code': 500,
              "message": e.message.toString(),
              "image": "assets/images/undraw/dream.svg"
            });
          }
        }
        break;
    }
  }
}
