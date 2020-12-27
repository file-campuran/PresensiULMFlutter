import 'package:absen_online/models/model.dart';

class ProfilePageModel {
  final UserModel user;
  final List<Map<String, dynamic>> value;

  ProfilePageModel(
    this.user,
    this.value,
  );

  factory ProfilePageModel.fromJson(Map<String, dynamic> json) {
    return ProfilePageModel(
      new UserModel.fromJson(json['user']),
      json['value'].cast<Map<String, dynamic>>() ?? [],
    );
  }
}
