import 'package:absen_online/models/model.dart';

class CategoryPageModel {
  final List<CategoryModel> category;

  CategoryPageModel(
    this.category,
  );

  factory CategoryPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable convertCategory = json['category'] ?? [];

    final listCategory = convertCategory.map((item) {
      return CategoryModel.fromJson(item);
    }).toList();

    return CategoryPageModel(
      listCategory,
    );
  }
}
