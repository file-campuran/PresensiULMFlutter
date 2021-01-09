import 'package:flutter/material.dart';
import 'package:absen_online/api/presensi.dart';
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
  JadwalListModel _jadwalData;
  Map<String, dynamic> _infoData;
  Map<String, dynamic> _errorData;
  bool _btnLoading = false;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    setState(() {
      _btnLoading = true;
    });
    final ApiModel result = await PresensiRepository().getJadwal();
    if (this.mounted) {
      setState(() {
        _btnLoading = false;
      });
      if (result.code == CODE.SUCCESS) {
        setState(() {
          _errorData = null;
          _infoData = result.message;
          _jadwalData = JadwalListModel.fromJson(result.data);
        });
      } else if (result.code == CODE.INFO) {
        setState(() {
          _errorData = null;
          _infoData = result.message;
        });
      } else if (result.code == CODE.TOKEN_EXPIRED) {
        BlocProvider.of<LoginBloc>(context).add(OnLogout());
      } else {
        setState(() {
          _errorData = result.message;
        });
      }
    }
  }

  ///Build list recent
  Widget _buildList() {
    if (_errorData != null) {
      return AppError(
        title: _errorData['title'].toString(),
        message: _errorData['content'].toString(),
        image: _errorData['image'],
        onPress: _loadData,
        btnRefreshLoading: _btnLoading,
      );
    }

    if (_infoData != null) {
      return AppInfo(
        title: _infoData['title'].toString(),
        message: _infoData['content'].toString(),
        image: _infoData['type'].toString() == 'hari' ? '' : Images.Calendar,
        mode: ViewMode.Lottie,
      );
    }

    if (_jadwalData?.list == null) {
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
    }

    return Column(
      children: _jadwalData.list
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
                      child: _buildList(),
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
