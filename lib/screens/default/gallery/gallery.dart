import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/models/model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

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
      backgroundColor: Color(0xff303030),
      appBar: AppCustomAppBar.defaultAppBar(
          leading: BackButton(),
          backgroundColor: Color(0xff303030),
          title: Translate.of(context).translate(''),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: Text(
                  "${_index + 1}/${widget.photo.length}",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: Colors.white),
                ),
              ),
            )
          ],
          context: context),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: Adapt.screenH() - 200,
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
                  alignment: Alignment(0.0, 1),
                  builder: SwiperPagination.dots,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: Adapt.screenW() * 0.8,
                    child: Html(
                      data: widget.photo[_index].description ?? '',
                      defaultTextStyle: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: Colors.white),
                      onLinkTap: (url) {
                        launchExternal(url);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                margin: EdgeInsets.only(bottom: 30),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
