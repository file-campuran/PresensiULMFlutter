import 'package:absen_online/models/model.dart';

class ProductListPageModel {
  final List<ProductModel> list;

  ProductListPageModel(
    this.list,
  );

  factory ProductListPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorList = json['list'] ?? [];

    final list = refactorList.map((item) {
      return ProductModel.fromJson(item);
    }).toList();

    return ProductListPageModel(list);
  }
}
