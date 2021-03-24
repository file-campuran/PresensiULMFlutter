import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'beranda_sliver_app_bar.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/widgets/widget.dart';
import 'beranda_swiper.dart';

class Beranda extends StatefulWidget {
  Beranda({Key key}) : super(key: key);

  @override
  _BerandaState createState() {
    return _BerandaState();
  }
}

class _BerandaState extends State<Beranda> {
  JadwalCubit _jadwalCubit;
  PengumumanCubit _pengumumanCubit;
  NotificationBloc _notificationBloc;
  final _controller = RefreshController(initialRefresh: false);

  @override
  void initState() {
    // _loadData();
    _pengumumanCubit = BlocProvider.of<PengumumanCubit>(context);
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _jadwalCubit = BlocProvider.of<JadwalCubit>(context);
    _jadwalCubit.initData();
    _pengumumanCubit.readMessage();
    super.initState();
  }

  ///Build list recent
  Widget _buildListJadwal() {
    return BlocBuilder<JadwalCubit, JadwalState>(builder: (_, state) {
      if (state is JadwalInfo) {
        return AppInfo(
          title: state.info['title'].toString(),
          message: state.info['content'].toString(),
          image: state.info['type'].toString() == 'hari' ? '' : Images.Calendar,
        );
      } else if (state is JadwalLoaded) {
        return Column(
          children: state.data.list
              .map(
                (item) => AppTimmer(
                  tanggal: item.tanggalManusia,
                  start: item.ruleStartTime,
                  end: item.ruleEndTime,
                  title: item.ruleStatus,
                  timeLeft: item.timeLeft.toString(),
                  isChecked: item.presensi != null,
                  item: item.presensi != null
                      ? AppPresensiItem(
                          item: item.presensi,
                          type: PresensiViewType.list,
                          onPressed: (presensiModel) {
                            Navigator.pushNamed(context, Routes.riwayatDetail,
                                arguments: presensiModel);
                          },
                        )
                      : null,
                ),
              )
              .toList(),
        );
      } else if (state is JadwalInfo) {
        return AppInfo(
          title: state.info['title'].toString(),
          message: state.info['content'].toString(),
          image: state.info['type'].toString() == 'hari'
              ? Images.Calendar
              : Images.Calendar,
        );
      } else if (state is JadwalError) {
        return AppError(
          title: state.error['title'].toString(),
          message: state.error['content'].toString(),
          image: state.error['image'],
          onPress: () => _jadwalCubit.reload(),
          btnRefreshLoading: state.isLoading,
        );
      }
      return Column(
        children: List.generate(2, (index) => index).map(
          (item) {
            return AppSkeleton(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).highlightColor,
                ),
                width: double.infinity,
                height: 120,
              ),
            );
          },
        ).toList(),
      );
    });
  }

  Future<void> _onRefresh() async {
    _jadwalCubit.reInit();
    _jadwalCubit.initData();
    _notificationBloc.add(OnReloadNotification());
    _controller.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark));

    final List<ImageModel> images = Application.remoteConfig?.banner == null
        ? []
        : Application.remoteConfig.banner
            .map((banner) => ImageModel(1, banner))
            .toList();

    return SafeArea(
      child: Scaffold(
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: _onRefresh,
          // onLoading: _onLoading,
          controller: _controller,
          header: ClassicHeader(
            idleText: Translate.of(context).translate('pull_down_refresh'),
            refreshingText: Translate.of(context).translate('refreshing'),
            completeText: Translate.of(context).translate('refresh_completed'),
            releaseText: Translate.of(context).translate('release_to_refresh'),
            refreshingIcon: SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          footer: ClassicFooter(
            loadingText: Translate.of(context).translate('loading'),
            canLoadingText: Translate.of(context).translate(
              'release_to_load_more',
            ),
            idleText: Translate.of(context).translate('pull_to_load_more'),
            loadStyle: LoadStyle.ShowWhenLoading,
            loadingIcon: SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                delegate: AppBarHomeSliver(expandedHeight: 90, banners: images),
                pinned: false,
                floating: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: <Widget>[
                        if (images.isNotEmpty) ...[
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 220,
                              child: HomeSwipe(images: images, height: 300)),
                        ],
                        SizedBox(
                          height: Dimens.padding,
                        ),
                        BlocBuilder<PengumumanCubit, PengumumanState>(
                          builder: (_, state) {
                            if (state is PengumumanData) {
                              if (state.data.isNotEmpty) {
                                final datas = state.data
                                    .where((e) => e.isRead == 0)
                                    .toList();

                                if (datas.isNotEmpty) {
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: Dimens.padding,
                                          right: Dimens.padding,
                                          bottom: 5,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  Translate.of(context)
                                                      .translate(
                                                          'announcement'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimens.padding,
                                            vertical: 5),
                                        child: AppAnnouncement(
                                          title: datas[0].judul,
                                          content: datas[0].konten,
                                          date: datas[0].humanDate(),
                                          onNext: () {
                                            if (datas[0].isRead != 1) {
                                              _pengumumanCubit
                                                  .markAsRead(datas[0].id);
                                            }
                                            Navigator.pushNamed(context,
                                                Routes.pengumumanDetail,
                                                arguments: datas[0]);
                                          },
                                          onTap: () {
                                            if (datas[0].isRead != 1) {
                                              _pengumumanCubit
                                                  .markAsRead(datas[0].id);
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                }
                              }
                            }
                            return Container();
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: Dimens.padding,
                            right: Dimens.padding,
                            bottom: 5,
                          ),
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    Translate.of(context)
                                        .translate('attendance_schedule'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: Dimens.padding,
                              right: Dimens.padding,
                              bottom: 20),
                          child: _buildListJadwal(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
