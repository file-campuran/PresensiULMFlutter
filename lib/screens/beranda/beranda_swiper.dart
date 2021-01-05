import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/configs/config.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeSwipe extends StatelessWidget {
  HomeSwipe({
    Key key,
    @required this.images,
    this.height,
  }) : super(key: key);
  final double height;
  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    if (images.length > 0) {
      return Swiper(
        onTap: (_) {
          Navigator.pushNamed(
            context,
            Routes.gallery,
            arguments: images,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: images[index].image,
          );
        },
        autoplayDelay: 3000,
        autoplayDisableOnInteraction: false,
        autoplay: true,
        itemCount: images.length,
        pagination: SwiperPagination(
          alignment: Alignment(0.0, 0.4),
          builder: SwiperPagination.dots,
        ),
      );
    }
    return Shimmer.fromColors(
      baseColor: Theme.of(context).hoverColor,
      highlightColor: Theme.of(context).highlightColor,
      enabled: true,
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
