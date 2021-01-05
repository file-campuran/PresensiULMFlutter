import 'dart:convert';

ApiModel apiModelFromJson(String str) => ApiModel.fromJson(json.decode(str));

String apiModelToJson(ApiModel data) => json.encode(data.toJson());

enum CODE { SUCCESS, ERROR, NOT_FOUND, VALIDATE }

class ApiModel {
  ApiModel({
    this.code,
    this.message,
    this.data,
  });

  CODE code;
  dynamic message;
  dynamic data;

  factory ApiModel.fromJson(Map<String, dynamic> json) => ApiModel(
        code: _convertStatusCode(json["code"]),
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
      };
}

// Private convert method
CODE _convertStatusCode(int code) {
  switch (code) {
    case 200:
      return CODE.SUCCESS;
      break;
    case 500:
      return CODE.ERROR;
    case 400:
      return CODE.VALIDATE;
      break;
    default:
      return CODE.NOT_FOUND;
  }
}
