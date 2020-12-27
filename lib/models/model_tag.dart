class TagModel {
  final int id;
  final String title;

  TagModel(
    this.id,
    this.title,
  );

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      json['id'] as int ?? 0,
      json['title'] as String ?? 'Unknoun',
    );
  }
}
