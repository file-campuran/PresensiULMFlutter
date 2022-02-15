import 'package:flutter/material.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/api/geocoder_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RiwayatDetail extends StatefulWidget {
  RiwayatDetail({Key key, this.item}) : super(key: key);

  final PresensiModel item;

  @override
  _RiwayatDetailState createState() {
    return _RiwayatDetailState();
  }
}

class _RiwayatDetailState extends State<RiwayatDetail> {
  String address = '';

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    address = await GeocoderRepository().getAddress(
        latitude: widget.item.latitude, longitude: widget.item.longitude);
    setState(() {});
    UtilLogger.log('ADDRESS', address);
  }

  ///On navigate map
  void _onLocation() {
    Navigator.pushNamed(
      context,
      Routes.location,
      arguments: LocationModel(
          1, address, widget.item.latitude, widget.item.longitude),
    );
  }

  ///Build banner UI
  Widget _buildBanner() {
    List<ImageModel> image = [
      ImageModel(0, widget.item.fileGambar, widget.item.deskripsiKinerja)
    ];
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.photoPreview,
          arguments: {"photo": image, "index": 0},
        );
      },
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: widget.item.fileGambar,
      ),
    );
  }

  ///Build info
  Widget _buildInfo() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.item.status,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Lokasi Presensi',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        address != ''
                            ? Text(
                                address,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontWeight: FontWeight.w600),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSkeleton(
                                    height: 10,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  SizedBox(height: 5),
                                  AppSkeleton(
                                    height: 10,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor),
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tanggal',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        widget.item.tanggalManusia,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Jam',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        widget.item.jamPresensi,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            widget.item.deskripsiKinerja,
            style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.3),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.7,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(Icons.arrow_back),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              wIcon(icon: Icons.map, onPress: _onLocation),
              Visibility(
                visible: widget.item.fileBerkas != null,
                child: wIcon(
                    icon: Icons.file_download,
                    onPress: () {
                      launchExternal(widget.item.fileBerkas);
                    }),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _buildBanner(),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Column(
                  children: <Widget>[
                    _buildInfo(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget wIcon({IconData icon, Function onPress}) {
    return Container(
      width: 60,
      child: IconButton(
        icon: Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(.2),
              borderRadius: BorderRadius.circular(20)),
          child: Icon(icon),
        ),
        onPressed: onPress,
      ),
    );
  }
}
