// To parse this JSON data, do
//
//     final token = tokenFromJson(jsonString);

import 'dart:convert';
import 'package:absen_online/utils/utils.dart';

Token tokenFromJson(String str) => Token.fromJson(json.decode(str));
Token tokenFromJwt(String str) => Token.fromJson(parseJwt(str));

String tokenToJson(Token data) => json.encode(data.toJson());

class Token {
  Token({
    this.iss,
    this.aud,
    this.iat,
    this.nbf,
    this.exp,
    this.user,
    this.key,
  });

  String iss;
  String aud;
  int iat;
  int nbf;
  int exp;
  User user;
  String key;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        iss: json["iss"],
        aud: json["aud"],
        iat: json["iat"],
        nbf: json["nbf"],
        exp: json["exp"],
        user: User.fromJson(json["user"]),
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "iss": iss,
        "aud": aud,
        "iat": iat,
        "nbf": nbf,
        "exp": exp,
        "user": user.toJson(),
        "key": key,
      };
}

class User {
  User({
    this.username,
    this.role,
    this.fakultas,
    this.prodi,
    this.namaFakultas,
    this.namaSingkatFakultas,
    this.namaProdi,
    this.nama,
  });

  String username;
  String role;
  String fakultas;
  String prodi;
  String namaFakultas;
  String namaSingkatFakultas;
  String namaProdi;
  String nama;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        role: json["role"],
        fakultas: json["fakultas"],
        prodi: json["prodi"],
        namaFakultas: json["namaFakultas"],
        namaSingkatFakultas: json["namaSingkatFakultas"],
        namaProdi: json["namaProdi"],
        nama: json["nama"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "role": role,
        "fakultas": fakultas,
        "prodi": prodi,
        "namaFakultas": namaFakultas,
        "namaSingkatFakultas": namaSingkatFakultas,
        "namaProdi": namaProdi,
        "nama": nama,
      };
}
