import 'package:absen_online/models/model.dart';

class ProductDetailPageModel {
  final ProductModel product;

  ProductDetailPageModel(this.product);

  factory ProductDetailPageModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailPageModel(ProductModel.fromJson(json));
  }
}
