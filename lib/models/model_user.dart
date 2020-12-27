class UserModel {
  final int id;
  final String name;
  final String nickname;
  final String image;
  final String link;
  final String level;
  final String description;
  final String tag;
  final double rate;
  final String token;

  UserModel(
    this.id,
    this.name,
    this.nickname,
    this.image,
    this.link,
    this.level,
    this.description,
    this.tag,
    this.rate,
    this.token,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['id'] as int ?? 0,
      json['full_name'] as String ?? 'Unknown',
      json['nickname'] as String ?? 'Unknown',
      json['photo'] as String ?? 'Unknown',
      json['url'] as String ?? 'Unknown',
      json['level'] as String ?? 'Unknown',
      json['description'] as String ?? 'Unknown',
      json['tag'] as String ?? 'Unknown',
      json['rate'] as double ?? 0.0,
      json['token'] as String ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'nickname': nickname,
      'photo': image,
      'url': link,
      'level': level,
      'description': description,
      'tag': tag,
      'rate': rate,
      'token': token,
    };
  }
}
