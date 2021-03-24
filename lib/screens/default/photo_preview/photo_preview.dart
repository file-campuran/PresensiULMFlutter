import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoPreview extends StatefulWidget {
  PhotoPreview({
    this.initialIndex,
    @required this.galleryList,
  }) : pageController = PageController(initialPage: initialIndex);

  final int initialIndex;
  final PageController pageController;
  final List<ImageModel> galleryList;

  @override
  State<StatefulWidget> createState() {
    return _PhotoPreviewState();
  }
}

class _PhotoPreviewState extends State<PhotoPreview> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  ///On change image
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  ///Build Item
  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final ImageModel item = widget.galleryList[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: new CachedNetworkImageProvider(item.image),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 1.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        actions: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "${Translate.of(context).translate('image')} ${currentIndex + 1}",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          PhotoViewGallery.builder(
            scrollPhysics: BouncingScrollPhysics(),
            builder: _buildItem,
            itemCount: widget.galleryList.length,
            pageController: widget.pageController,
            onPageChanged: onPageChanged,
            scrollDirection: Axis.horizontal,
          ),
          Positioned(
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    gradient: new LinearGradient(
                      end: const Alignment(0.0, -1),
                      begin: const Alignment(0.0, 0.1),
                      colors: <Color>[
                        const Color(0x8A000000),
                        Colors.black12.withOpacity(0.0)
                      ],
                    ),
                  ),
                  child: Text(
                    "${widget.galleryList[currentIndex].description ?? ''}",
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
