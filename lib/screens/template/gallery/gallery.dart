import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Gallery extends StatefulWidget {
  final List<ImageModel> photo;

  Gallery({this.photo}) : super();

  @override
  _GalleryState createState() {
    return _GalleryState();
  }
}

class _GalleryState extends State<Gallery> {
  final _controller = SwiperController();
  final _listController = ScrollController();

  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  ///On preview photo
  void _onPreviewPhoto(int index) {
    Navigator.pushNamed(
      context,
      Routes.photoPreview,
      arguments: {"photo": widget.photo, "index": index},
    );
  }

  ///On select image
  void _onSelectImage(int index) {
    _controller.move(index);
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Swiper(
                controller: _controller,
                onIndexChanged: (index) {
                  setState(() {
                    _index = index;
                  });
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _onPreviewPhoto(index);
                    },
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.photo[index].image,
                    ),
                  );
                },
                itemCount: widget.photo.length,
                pagination: SwiperPagination(
                  alignment: Alignment(0.0, 0.9),
                  builder: SwiperPagination.dots,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    "${_index + 1}/${widget.photo.length}",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              height: 70,
              margin: EdgeInsets.only(bottom: 20),
              child: ListView.builder(
                controller: _listController,
                padding: EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: widget.photo.length,
                itemBuilder: (context, index) {
                  final item = widget.photo[index];
                  return GestureDetector(
                    onTap: () {
                      _onSelectImage(index);
                    },
                    child: Container(
                      width: 70,
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: index == _index
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        image: DecorationImage(
                          image: new CachedNetworkImageProvider(item.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
