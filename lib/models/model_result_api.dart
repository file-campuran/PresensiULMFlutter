class ResultApiModel {
  final bool success;
  final String message;
  final Map<String, dynamic> data;
  final int code;

  ResultApiModel(
    this.success,
    this.message,
    this.data,
    this.code,
  );

  factory ResultApiModel.fromJson(Map<String, dynamic> json) {
    return ResultApiModel(
      json['success'] as bool ?? false,
      json['message'] as String ?? 'Unknown',
      json['data'] as Map<String, dynamic> ?? {},
      json['code'] as int ?? 0,
    );
  }
}
