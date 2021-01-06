class ImageModel {
  final int id;
  final String image;

  ImageModel(
    this.id,
    this.image,
  );

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      json['id'] as int ?? 0,
      json['image'] as String ?? "Unknown",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
    };
  }
}
