// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.role,
    this.nip,
    this.nama,
    this.namaLengkap,
    this.nidn,
    this.tempatLahir,
    this.tglLahir,
    this.jenisKelamin,
    this.agama,
    this.kodeProdi,
    this.statusDosen,
    this.statusAktif,
    this.gelarDepan,
    this.gelarBelakang,
    this.foto,
    this.noHp,
    this.email,
    this.alamatRumah,
    this.alamatRumahPresensi,
    this.alamatRumahKota,
    this.alamatKantor,
    this.alamatKantorKota,
    this.meluluskanS0,
    this.meluluskanS1,
    this.meluluskanS2,
    this.noSertifikatDosen,
    this.tglSerdos,
    this.tmtPensiun,
    this.statusHonorer,
    this.homebaseFakultas,
    this.feederIdSdm,
    this.golDarah,
    this.statusKepegawaian,
  });

  String role;
  String nip;
  String nama;
  String namaLengkap;
  String nidn;
  String tempatLahir;
  DateTime tglLahir;
  String jenisKelamin;
  String agama;
  String kodeProdi;
  String statusDosen;
  String statusAktif;
  dynamic gelarDepan;
  dynamic gelarBelakang;
  dynamic foto;
  dynamic noHp;
  String email;
  String alamatRumah;
  String alamatRumahPresensi;
  String alamatRumahKota;
  String alamatKantor;
  String alamatKantorKota;
  dynamic meluluskanS0;
  dynamic meluluskanS1;
  dynamic meluluskanS2;
  String noSertifikatDosen;
  String tglSerdos;
  String tmtPensiun;
  dynamic statusHonorer;
  String homebaseFakultas;
  String feederIdSdm;
  dynamic golDarah;
  String statusKepegawaian;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        role: json["role"],
        nip: json["nip"],
        nama: json["nama"],
        namaLengkap:
            "${json["gelar_depan"] ?? ''} ${json["nama"]} ${json["gelar_belakang"] ?? ''}"
                .trim(),
        nidn: json["nidn"],
        tempatLahir: json["tempat_lahir"],
        tglLahir: json["tgl_lahir"] != null
            ? DateTime.parse(json["tgl_lahir"])
            : DateTime.now(),
        jenisKelamin: json["jenis_kelamin"],
        agama: json["agama"],
        kodeProdi: json["kode_prodi"],
        statusDosen: json["status_dosen"],
        statusAktif: json["status_aktif"],
        gelarDepan: json["gelar_depan"],
        gelarBelakang: json["gelar_belakang"],
        foto: json["foto"],
        noHp: json["no_hp"],
        email: json["email"],
        alamatRumah: json["alamat_rumah"],
        alamatRumahPresensi: json["alamat_rumah_presensi"],
        alamatRumahKota: json["alamat_rumah_kota"],
        alamatKantor: json["alamat_kantor"],
        alamatKantorKota: json["alamat_kantor_kota"],
        meluluskanS0: json["meluluskan_s0"],
        meluluskanS1: json["meluluskan_s1"],
        meluluskanS2: json["meluluskan_s2"],
        noSertifikatDosen: json["no_sertifikat_dosen"],
        tglSerdos: json["tgl_serdos"],
        tmtPensiun: json["tmt_pensiun"],
        statusHonorer: json["status_honorer"],
        homebaseFakultas: json["homebase_fakultas"],
        feederIdSdm: json["feeder_id_sdm"],
        golDarah: json["gol_darah"],
        statusKepegawaian: json["status_kepegawaian"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "nip": nip,
        "nama": nama,
        "nidn": nidn,
        "tempat_lahir": tempatLahir,
        "tgl_lahir":
            "${tglLahir.year.toString().padLeft(4, '0')}-${tglLahir.month.toString().padLeft(2, '0')}-${tglLahir.day.toString().padLeft(2, '0')}",
        "jenis_kelamin": jenisKelamin,
        "agama": agama,
        "kode_prodi": kodeProdi,
        "status_dosen": statusDosen,
        "status_aktif": statusAktif,
        "gelar_depan": gelarDepan,
        "gelar_belakang": gelarBelakang,
        "foto": foto,
        "no_hp": noHp,
        "email": email,
        "alamat_rumah": alamatRumah,
        "alamat_rumah_presensi": alamatRumahPresensi,
        "alamat_rumah_kota": alamatRumahKota,
        "alamat_kantor": alamatKantor,
        "alamat_kantor_kota": alamatKantorKota,
        "meluluskan_s0": meluluskanS0,
        "meluluskan_s1": meluluskanS1,
        "meluluskan_s2": meluluskanS2,
        "no_sertifikat_dosen": noSertifikatDosen,
        "tgl_serdos": tglSerdos,
        "tmt_pensiun": tmtPensiun,
        "status_honorer": statusHonorer,
        "homebase_fakultas": homebaseFakultas,
        "feeder_id_sdm": feederIdSdm,
        "gol_darah": golDarah,
        "status_kepegawaian": statusKepegawaian,
      };

  @override
  String toString() {
    return json.encode(toJson());
  }
}
