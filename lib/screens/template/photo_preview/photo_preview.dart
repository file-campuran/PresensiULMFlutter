import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
      imageProvider: AssetImage(item.image),
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
    );
  }
}
