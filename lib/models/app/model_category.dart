import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';

class CategoryModel {
  final int id;
  final String title;
  final int count;
  final String image;
  final IconData icon;
  final Color color;
  final ProductType type;

  CategoryModel({
    this.id,
    this.title,
    this.count,
    this.image,
    this.icon,
    this.color,
    this.type,
  });

  static ProductType _setType(String type) {
    switch (type) {
      case 'shop':
        return ProductType.shop;
      case 'drink':
        return ProductType.drink;
      case 'event':
        return ProductType.event;
      case 'estate':
        return ProductType.estate;
      case 'job':
        return ProductType.job;
      case 'restaurant':
        return ProductType.restaurant;
      case 'automotive':
        return ProductType.automotive;
      case 'hotel':
        return ProductType.hotel;
      default:
        return ProductType.more;
    }
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final icon = Icons.alarm;
    final color = Color(0xFF58d68d);
    return CategoryModel(
      id: json['id'] as int ?? 0,
      title: json['title'] as String ?? 'Unknown',
      count: json['count'] as int ?? 0,
      image: json['image'] as String ?? 'Unknown',
      icon: Icons.alarm,
      color: color,
      type: ProductType.hotel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'count': count,
      'image': image,
    };
  }
}
