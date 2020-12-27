import 'package:absen_online/models/model.dart';

class HomePageModel {
  final List<ImageModel> banner;
  final List<CategoryModel> category;
  final List<ProductModel> popular;
  final List<ProductModel> list;

  HomePageModel(
    this.banner,
    this.category,
    this.popular,
    this.list,
  );

  factory HomePageModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorBanner = json['banner'] ?? [];
    final Iterable refactorCategory = json['category'] ?? [];
    final Iterable refactorPopular = json['popular'] ?? [];
    final Iterable refactorList = json['list'] ?? [];

    final listBanner = refactorBanner.map((item) {
      return ImageModel.fromJson(item);
    }).toList();

    final listCategory = refactorCategory.map((item) {
      return CategoryModel.fromJson(item);
    }).toList();

    final listPopular = refactorPopular.map((item) {
      return ProductModel.fromJson(item);
    }).toList();

    final listProduct = refactorList.map((item) {
      return ProductModel.fromJson(item);
    }).toList();

    return HomePageModel(
      listBanner,
      listCategory,
      listPopular,
      listProduct,
    );
  }
}
