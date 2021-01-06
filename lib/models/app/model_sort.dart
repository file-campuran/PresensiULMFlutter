import 'package:flutter/material.dart';

class SortModel {
  final String code;
  final String name;
  final IconData icon;

  SortModel(
    this.code,
    this.name,
    this.icon,
  );

  factory SortModel.fromJson(Map<String, dynamic> json) {
    return SortModel(
      json['code'] as String ?? "Unknown",
      json['name'] as String ?? "Unknown",
      json['icon'] as IconData ?? Icons.help,
    );
  }
}
