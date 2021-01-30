class ImageModel {
  final int id;
  final String image;
  final String description;

  ImageModel(this.id, this.image, [this.description]);

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      json['id'] as int ?? 0,
      json['image'] as String ?? "Unknown",
      json['description'] as String ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'description': description,
    };
  }
}
