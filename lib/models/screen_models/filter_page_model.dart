class FilterPageModel {
  final List<String> category;
  final List<String> service;

  FilterPageModel(
    this.category,
    this.service,
  );

  factory FilterPageModel.fromJson(Map<String, dynamic> json) {
    return FilterPageModel(
      json['category'],
      json['service'],
    );
  }
}
