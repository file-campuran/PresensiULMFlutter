import 'package:absen_online/models/model.dart';

class ReviewPageModel {
  final UserModel author;
  final RateModel rate;
  final List<CommentModel> comment;

  ReviewPageModel(
    this.author,
    this.rate,
    this.comment,
  );

  factory ReviewPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorComment = json['comment'] ?? [];
    final comment = refactorComment.map((item) {
      return CommentModel.fromJson(item);
    }).toList();

    return ReviewPageModel(
      UserModel.fromJson(json['author']),
      RateModel.fromJson(json['rate']),
      comment,
    );
  }
}
