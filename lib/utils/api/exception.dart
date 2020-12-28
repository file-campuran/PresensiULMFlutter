import 'dart:io';
import 'package:dio/dio.dart';

class MyException {
  static getException(DioError e) {
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
          return {
            "message": 'Dictionary.socketException',
            "image": "assets/images/undraw/astronot.svg"
          };
        }
        break;

      case FormatException:
        {
          return {
            "message": "Dictionary.formatException",
            "image": "assets/images/undraw/warning.svg"
          };
        }
        break;

      case HttpException:
        {
          return {
            "message": "Dictionary.httpException",
            "image": "assets/images/undraw/warning.svg"
          };
        }
        break;

      default:
        {
          if (e.response == null) {
            return {"message": "${e.message.toString()}"};
          } else if (e.response.statusCode == 500) {
            return {
              "message": "Dictionary.errorInternal",
              "image": "assets/images/undraw/error.svg"
            };
          } else if (e.response.statusCode == 401) {
            return {
              "status_code": 401,
              "message": "${e.response.data['error']}",
              "image": "assets/images/undraw/dream.svg"
            };
          } else if (e.response.statusCode == 404) {
            return {
              "status_code": 404,
              "message": "Dictionary.errorNotFound",
              "image": "assets/images/undraw/dream.svg"
            };
          }

          if (e.response != null) {
            return {"message": "${e.response.data['error']}"};
          } else {
            return {"message": "${e.message.toString()}"};
          }
        }
        break;
    }
  }
}
