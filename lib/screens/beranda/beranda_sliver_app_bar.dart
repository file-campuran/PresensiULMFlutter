import 'package:absen_online/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppBarHomeSliver extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final List<ImageModel> banners;

  AppBarHomeSliver({this.expandedHeight, this.banners});

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    // NotificationBloc _notificationBloc;
    // _notificationBloc = BlocProvider.of<NotificationBloc>(context);

    return Column(
      children: [
        AppBar(
          centerTitle: false,
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Color(0xff303030)
              : Colors.white,
          elevation: 0,
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: MyIconDuotone(
                        MyIconDuotoneIcon.calendar,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.hariLibur);
                    },
                  ),
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Stack(
                          children: [
                            Center(
                              child: MyIconDuotone(
                                MyIconDuotoneIcon.alarm,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 0,
                              child: BlocBuilder<NotificationBloc,
                                  NotificationState>(
                                builder: (context, state) {
                                  if (state is NotificationData) {
                                    if (state.data.count != 0) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
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
                        )),
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.notification);
                    },
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: MyIconDuotone(
                        MyIconDuotoneIcon.search,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.faq);
                    },
                  ),
                ],
              ),
            )
          ],
          title: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: Environment.logoUlmOnline,
                ),
              ),
              SizedBox(width: 15),
              Text(
                Environment.APP_NAME,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Color(0xff303030)),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
