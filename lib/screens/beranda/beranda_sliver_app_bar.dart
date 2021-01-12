import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'beranda_swiper.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBarHomeSliver extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final List<ImageModel> banners;

  AppBarHomeSliver({this.expandedHeight, this.banners});

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    NotificationBloc _notificationBloc;
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: HomeSwipe(
            images: banners,
            height: expandedHeight,
          ),
        ),
        SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Stack(
                children: <Widget>[
                  AppTransparentButton(
                      size: 50,
                      icon: FontAwesomeIcons.bell,
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.notification);
                      }),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationData) {
                          if (state.data.count != 0) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                Text(
                                  state.data.count.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container();
                        }
                        return Container();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 44,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () {
                    // PresensiRepository si = new PresensiRepository();
                    // si.getKuesioner();

                    Navigator.pushNamed(context, Routes.faq);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hoverColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'FAQ',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            VerticalDivider(),
                            Icon(
                              Icons.help,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
