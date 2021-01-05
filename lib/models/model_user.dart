import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  final String nip;
  final String name;
  final String role;
  String alamat;
  String noHp;
  String golDarah;

  UserModel(
    this.nip,
    this.name,
    this.role,
    this.alamat,
    this.noHp,
    this.golDarah,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['nip'] as String ?? 'Unknown',
      json['name'] as String ?? 'Unknown',
      json['role'] as String ?? 'Unknown',
      json['alamat'] as String ?? '-',
      json['noHp'] as String ?? '-',
      json['golDarah'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nip': nip,
      'name': name,
      'role': role,
      'alamat': alamat,
      'noHp': noHp,
      'golDarah': golDarah,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}
