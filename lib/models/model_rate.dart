class RateModel {
  final double one;
  final double two;
  final double three;
  final double four;
  final double five;
  final int range;
  final double avg;
  final int total;

  RateModel(
    this.one,
    this.two,
    this.three,
    this.four,
    this.five,
    this.range,
    this.avg,
    this.total,
  );

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      json['one'] as double ?? 0.0,
      json['two'] as double ?? 0.0,
      json['three'] as double ?? 0.0,
      json['four'] as double ?? 0.0,
      json['five'] as double ?? 0.0,
      json['range'] as int ?? 5,
      json['avg'] as double ?? 0.0,
      json['total'] as int ?? 5,
    );
  }
}
