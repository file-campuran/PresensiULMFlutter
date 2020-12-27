class IconModel {
  final String title;
  final String icon;

  IconModel(
    this.title,
    this.icon,
  );

  factory IconModel.fromJson(Map<String, dynamic> json) {
    return IconModel(
      json['title'] as String ?? "Unknown",
      json['icon'] as String ?? "Unknown",
    );
  }
}
