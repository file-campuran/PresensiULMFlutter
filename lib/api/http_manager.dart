import 'package:dio/dio.dart';
import 'package:absen_online/utils/services/logger.dart';

String dioErrorHandle(DioError error) {
  UtilLogger.log("ERROR", error);
  switch (error.type) {
    case DioErrorType.RESPONSE:
      return error.response?.data['message'] ?? 'Unknown error';

    case DioErrorType.SEND_TIMEOUT:
    case DioErrorType.RECEIVE_TIMEOUT:
      return "request_time_out";

    default:
      return "connect_to_server_fail";
  }
}

class HTTPManager {
  BaseOptions baseOptions = BaseOptions(
    baseUrl: "https://simari.ulm.ac.id/",
    connectTimeout: 30000,
    receiveTimeout: 30000,
    headers: {},
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );

  ///Post method
  Future<dynamic> post({
    String url,
    Map<String, dynamic> data,
    Options options,
  }) async {
    UtilLogger.log("POST URL", url);
    UtilLogger.log("DATA", data);
    Dio dio = new Dio(baseOptions);
    try {
      final response = await dio.post(
        url,
        data: data,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      return {"message": dioErrorHandle(error)};
    }
  }

  ///Get method
  Future<dynamic> get({
    String url,
    Map<String, dynamic> params,
    Options options,
  }) async {
    UtilLogger.log("GET URL", url);
    UtilLogger.log("PARAMS", params);
    Dio dio = new Dio(baseOptions);
    try {
      final response = await dio.get(
        url,
        queryParameters: params,
        options: options,
      );
      return response.data;
    } on DioError catch (error) {
      return {"message": dioErrorHandle(error)};
    }
  }

  factory HTTPManager() {
    return HTTPManager._internal();
  }

  HTTPManager._internal();
}

HTTPManager httpManager = HTTPManager();
