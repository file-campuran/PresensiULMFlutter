import 'package:absen_online/models/model.dart';

class CommentModel {
  final int id;
  final UserModel user;
  final String title;
  final String comment;
  final String createDate;
  final num rate;

  CommentModel(
    this.id,
    this.user,
    this.title,
    this.comment,
    this.createDate,
    this.rate,
  );

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      json['id'] as int ?? 0,
      UserModel.fromJson(json['user']),
      json['title'] as String ?? 'Unknown',
      json['comment'] as String ?? 'Unknown',
      json['created_date'] as String ?? 'Unknown',
      json['rate'] as num ?? 0.0,
    );
  }
}
