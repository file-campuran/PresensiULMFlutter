import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';

class TabModel {
  final int id;
  final String key;
  final GlobalKey keyContentItem;
  final GlobalKey keyTabItem;
  final String title;
  final List<ProductModel> list;

  TabModel(
    this.id,
    this.key,
    this.keyContentItem,
    this.keyTabItem,
    this.title,
    this.list,
  );

  static List<ProductModel> _setList(list) {
    if (list != null) {
      final Iterable refactorList = list;
      return refactorList.map((item) {
        return ProductModel.fromJson(item);
      }).toList();
    }
    return null;
  }

  factory TabModel.fromJson(Map<String, dynamic> json) {
    return TabModel(
      json['id'] as int ?? 0,
      json['key'] as String ?? 'Unknown',
      GlobalKey(),
      GlobalKey(),
      json['title'] as String ?? 'Unknown',
      _setList(json['list']),
    );
  }
}
