import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'beranda_sliver_app_bar.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/widgets/widget.dart';

class Beranda extends StatefulWidget {
  Beranda({Key key}) : super(key: key);

  @override
  _BerandaState createState() {
    return _BerandaState();
  }
}

class _BerandaState extends State<Beranda> {
  JadwalCubit _jadwalCubit;

  @override
  void initState() {
    // _loadData();
    _jadwalCubit = BlocProvider.of<JadwalCubit>(context);
    _jadwalCubit.initData();
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
          image: state.info['type'].toString() == 'hari' ? '' : Images.Calendar,
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
            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: AppPresensiItem(type: PresensiViewType.small),
            );
          },
        ).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: AppBarHomeSliver(
                expandedHeight: 300,
                banners: Application.remoteConfig?.banner == null
                    ? []
                    : Application.remoteConfig.banner
                        .map((banner) => ImageModel(1, banner))
                        .toList()),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 15,
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
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: _buildListJadwal(),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
