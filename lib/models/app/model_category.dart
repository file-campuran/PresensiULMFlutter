import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';

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

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
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
