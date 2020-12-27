import 'package:absen_online/models/model.dart';

class AboutUsPageModel {
  final String banner;
  final String whoWeAre;
  final List<String> whatWeDo;
  final List<UserModel> team;

  AboutUsPageModel(
    this.banner,
    this.whoWeAre,
    this.whatWeDo,
    this.team,
  );

  factory AboutUsPageModel.fromJson(Map<String, dynamic> json) {
    final Iterable refactorTeam = json['team'] ?? [];

    final listTeam = refactorTeam.map((item) {
      return UserModel.fromJson(item);
    }).toList();

    return AboutUsPageModel(
      json['banner'] as String ?? 'Unknown',
      json['who_we_are'] as String ?? 'Unknown',
      json['what_we_do'].cast<String>() ?? [],
      listTeam,
    );
  }
}
