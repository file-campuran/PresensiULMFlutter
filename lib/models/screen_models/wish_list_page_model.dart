import 'package:absen_online/models/model.dart';

class WishListPageModel {
  final List<ProductModel> list;

  WishListPageModel(
    this.list,
  );

  factory WishListPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorList = json['list'] ?? [];

    final list = refactorList.map((item) {
      return ProductModel.fromJson(item);
    }).toList();

    return WishListPageModel(list);
  }
}
