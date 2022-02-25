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
        viewportFraction: 0.9,
        onTap: (_) {
          Navigator.pushNamed(
            context,
            Routes.photoPreview,
            arguments: {'photo': images, 'index': 0},
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin:
                EdgeInsets.symmetric(vertical: Dimens.padding, horizontal: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              // margin: EdgeInsets.only(bottom: 25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: images[index].image,
                ),
              ),
            ),
          );
        },
        autoplayDelay: 5000,
        autoplayDisableOnInteraction: false,
        autoplay: true,
        itemCount: images.length,
        pagination: SwiperPagination(
          alignment: Alignment(0, .9),
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
