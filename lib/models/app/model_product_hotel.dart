import 'package:absen_online/models/model.dart';

class HotelProductModel extends ProductModel {
  final List<ProductModel> nearly;

  HotelProductModel(
      int id,
      String title,
      String subtitle,
      String image,
      String createDate,
      bool like,
      num rate,
      num numRate,
      String rateText,
      String status,
      bool favorite,
      String address,
      String phone,
      String email,
      String website,
      String hour,
      String description,
      String date,
      String priceRange,
      List<HourModel> hourDetail,
      List<IconModel> service,
      List<ImageModel> photo,
      List<ProductModel> feature,
      List<ProductModel> related,
      LocationModel location,
      UserModel author,
      ProductType type,
      this.nearly)
      : super(
          id,
          title,
          subtitle,
          image,
          createDate,
          like,
          rate,
          numRate,
          rateText,
          status,
          favorite,
          address,
          phone,
          email,
          website,
          hour,
          description,
          date,
          priceRange,
          hourDetail,
          service,
          photo,
          feature,
          related,
          location,
          author,
          type,
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

  static List<ProductModel> _setNearly(nearly) {
    if (nearly != null) {
      final Iterable refactorNearly = nearly;
      return refactorNearly.map((item) {
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

  factory HotelProductModel.fromJson(Map<String, dynamic> json) {
    return HotelProductModel(
      json['id'] as int ?? 0,
      json['title'] as String ?? 'Unknown',
      json['subtitle'] as String ?? 'Unknown',
      json['image'] as String ?? 'Unknown',
      json['created_date'] as String ?? 'Unknown',
      json['like'] as bool ?? false,
      json['rate'] as num ?? 0,
      json['num_rate'] as num ?? 0,
      json['rate_text'] as String ?? 'Unknown',
      json['status'] as String ?? 'Unknown',
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
      _setNearly(json['nearly']),
    );
  }
}
