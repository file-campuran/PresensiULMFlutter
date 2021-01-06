import 'package:absen_online/models/model.dart';

enum ProductType {
  place,
  hotel,
  shop,
  drink,
  event,
  estate,
  job,
  restaurant,
  automotive,
  more
}

class ProductModel {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final String createDate;
  final bool like;
  final num rate;
  final num numRate;
  final String rateText;
  final String status;
  final bool favorite;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String hour;
  final String description;
  final String date;
  final String priceRange;
  final List<ImageModel> photo;
  final List<HourModel> hourDetail;
  final List<IconModel> service;
  final List<ProductModel> feature;
  final List<ProductModel> related;
  final LocationModel location;
  final UserModel author;
  final ProductType type;

  ProductModel(
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.createDate,
    this.like,
    this.rate,
    this.numRate,
    this.rateText,
    this.status,
    this.favorite,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.hour,
    this.description,
    this.date,
    this.priceRange,
    this.hourDetail,
    this.service,
    this.photo,
    this.feature,
    this.related,
    this.location,
    this.author,
    this.type,
  );

  static List<HourModel> _setHourDetail(hour) {
    if (hour != null) {
      final Iterable refactorHour = hour;
      return refactorHour.map((item) {
        return HourModel.fromJson(item);
      }).toList();
    }
    return null;
  }

  static List<IconModel> _setService(icon) {
    if (icon != null) {
      final Iterable refactorService = icon;
      return refactorService.map((item) {
        return IconModel.fromJson(item);
      }).toList();
    }
    return null;
  }

  static List<ImageModel> _setPhoto(photo) {
    if (photo != null) {
      final Iterable refactorPhoto = photo;
      return refactorPhoto.map((item) {
        return ImageModel.fromJson(item);
      }).toList();
    }
    return null;
  }

  static List<ProductModel> _setFeature(feature) {
    if (feature != null) {
      final Iterable refactorFeature = feature;
      return refactorFeature.map((item) {
        return ProductModel.fromJson(item);
      }).toList();
    }
    return null;
  }

  static List<ProductModel> _setRelated(related) {
    if (related != null) {
      final Iterable refactorRelated = related;
      return refactorRelated.map((item) {
        return ProductModel.fromJson(item);
      }).toList();
    }
    return null;
  }

  static LocationModel _setLocation(Map<String, dynamic> location) {
    if (location != null) {
      return LocationModel.fromJson(location);
    }
    return null;
  }

  static UserModel _setAuthor(Map<String, dynamic> author) {
    if (author != null) {
      return UserModel.fromJson(author);
    }
    return null;
  }

  static ProductType _setType(String type) {
    switch (type) {
      case 'hotel':
        return ProductType.hotel;
      case 'shop':
        return ProductType.shop;
      case 'drink':
        return ProductType.drink;
      case 'event':
        return ProductType.event;
      case 'estate':
        return ProductType.estate;
      case 'job':
        return ProductType.job;
      case 'restaurant':
        return ProductType.restaurant;
      case 'automotive':
        return ProductType.automotive;
      default:
        return ProductType.place;
    }
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      json['id'] as int ?? 0,
      json['title'] as String ?? 'Unknown',
      json['subtitle'] as String ?? 'Unknown',
      json['image'] as String ?? 'Unknown',
      json['created_date'] as String ?? 'Unknown',
      json['like'] as bool ?? false,
      json['rate'] as num ?? 0,
      json['num_rate'] as num ?? 0,
      json['rate_text'] as String ?? 'Unknown',
      json['status'] as String ?? null,
      json['favorite'] as bool ?? false,
      json['address'] as String ?? 'Unknown',
      json['phone'] as String ?? 'Unknown',
      json['email'] as String ?? 'Unknown',
      json['website'] as String ?? 'Unknown',
      json['hour'] as String ?? 'Unknown',
      json['description'] as String ?? 'Unknown',
      json['date'] as String ?? 'Unknown',
      json['price_range'] as String ?? 'Unknown',
      _setHourDetail(json['hour_detail']),
      _setService(json['service']),
      _setPhoto(json['photo']),
      _setFeature(json['feature']),
      _setRelated(json['related']),
      _setLocation(json['location']),
      _setAuthor(json['author']),
      _setType(json['type']),
    );
  }
}
