import 'package:absen_online/models/model.dart';

class SearchHistoryPageModel {
  final List<TagModel> tag;
  final List<TagModel> discover;
  final List<ProductModel> popular;
  final List<ProductModel> history;

  SearchHistoryPageModel(
    this.tag,
    this.discover,
    this.popular,
    this.history,
  );

  factory SearchHistoryPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorTag = json['tag'] ?? [];
    final Iterable refactorDiscover = json['discover'] ?? [];
    final Iterable refactorPopular = json['popular'] ?? [];
    final Iterable refactorHistory = json['history'] ?? [];

    final listTag = refactorTag.map((item) {
      return TagModel.fromJson(item);
    }).toList();

    final listDiscover = refactorDiscover.map((item) {
      return TagModel.fromJson(item);
    }).toList();

    final listPopular = refactorPopular.map((item) {
      return ProductModel.fromJson(item);
    }).toList();

    final listHistory = refactorHistory.map((item) {
      return ProductModel.fromJson(item);
    }).toList();

    return SearchHistoryPageModel(
      listTag,
      listDiscover,
      listPopular,
      listHistory,
    );
  }
}
