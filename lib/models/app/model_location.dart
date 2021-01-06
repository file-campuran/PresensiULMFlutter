class LocationModel {
  final int id;
  final String name;
  final double lat;
  final double long;

  LocationModel(
    this.id,
    this.name,
    this.lat,
    this.long,
  );

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      json['id'] as int ?? 0,
      json['name'] as String ?? "Unknown",
      json['lat'] as double ?? 0.0,
      json['long'] as double ?? 0.0,
    );
  }
}
