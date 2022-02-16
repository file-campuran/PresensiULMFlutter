import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:absen_online/configs/config.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Location extends StatefulWidget {
  final LocationModel location;
  final bool withBlueZone;
  final String title;

  Location(
      {Key key,
      this.location,
      this.withBlueZone = true,
      this.title = 'location'})
      : super(key: key);

  @override
  _LocationState createState() {
    return _LocationState();
  }
}

class _LocationState extends State<Location> {
  Set<Circle> circles;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  BitmapDescriptor myIcon;
  List<Polygon> myPolygons = [];
  GoogleMapController _mapController;

  @override
  void initState() {
    _onLoadMap();
    initLokasiPresensi();
    initKecamatan();
    super.initState();
  }

  void initLokasiPresensi() async {
    if (Application.lokasiPresensiList == null) {
      final response = await PresensiRepository().getLokasiPresensi();

      if (response.code == CODE.SUCCESS) {
        final lokasiModel = LokasiPresensiListModel.fromMap(response.data);

        setState(() {
          Application.lokasiPresensiList = lokasiModel;
        });
      }
    }
  }

  void initKecamatan() async {
    if (Application.kecamatanListModel == null) {
      final response = await PresensiRepository().getKecamatan();

      if (response.code == CODE.SUCCESS) {
        final lokasiModel = KecamatanListModel.fromMap(response.data);

        setState(() {
          Application.kecamatanListModel = lokasiModel;
        });
      }
    }
  }

  ///On load map
  void _onLoadMap() async {
    List<Circle> circle = [];
    MarkerId markerId;
    Marker marker;

    if (widget.location.lat != null) {
      markerId = MarkerId('MY_LOCATION');
      marker = Marker(
        markerId: markerId,
        position: LatLng(widget.location.lat, widget.location.long),
        infoWindow: InfoWindow(title: 'Lokasi Saya'),
        onTap: () {},
      );
    }

    // Set Kecamatan Polygon
    if (Application.kecamatanListModel != null) {
      Application.kecamatanListModel.rows.forEach((kecamatan) {
        List<LatLng> coordsToAdd = [];
        kecamatan.kordinat.forEach((coordinat) {
          coordsToAdd.add(LatLng(double.parse(coordinat[0].toString()),
              double.parse(coordinat[1].toString())));
        });

        myPolygons.add(Polygon(
            polygonId: PolygonId(kecamatan.kode.toString()),
            points: coordsToAdd,
            strokeColor: kecamatan.color.withOpacity(.4),
            fillColor: kecamatan.color.withOpacity(.2),
            strokeWidth: 2));
      });
    }

    //Set Icon Radius
    // myIcon = await createCustomMarkerBitmap('TEST');
    myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(100, 2)),
        'assets/images/lokasi_presensi80.png');

    if (Application.lokasiPresensiList != null) {
      for (var item in Application.lokasiPresensiList.list ?? []) {
        circle.add(Circle(
          strokeWidth: 0,
          fillColor: Color.fromRGBO(0, 100, 255, 0.2),
          circleId: CircleId(item.id),
          center: LatLng(item.latitude, item.longitude),
          radius: item.radius,
        ));

        final lokasiMarkerPresensi = MarkerId(item.id);
        final lokasiMarker = Marker(
          markerId: lokasiMarkerPresensi,
          position: LatLng(item.latitude, item.longitude),
          infoWindow: InfoWindow(title: item.namaLokasi),
          onTap: () {},
          icon: myIcon,
        );
        _markers[lokasiMarkerPresensi] = lokasiMarker;
      }

      circles = Set.from(circle);
    }

    setState(() {
      if (widget.location.lat != null) {
        _markers[markerId] = marker;
      }
    });
  }

  double _bottomPanelSliderHeightOpen;
  double _bottomPanelSliderHeightClosed = 95.0;
  @override
  Widget build(BuildContext context) {
    _bottomPanelSliderHeightOpen = MediaQuery.of(context).size.height * .6;
    _bottomPanelSliderHeightClosed = MediaQuery.of(context).size.height * .28;

    return Scaffold(
      appBar: widget.title == null
          ? null
          : AppCustomAppBar.defaultAppBar(
              title: Translate.of(context).translate('location'),
              context: context),
      body: widget.title == null
          ? wGoogleMap()
          : SlidingUpPanel(
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
              backdropEnabled: true,
              maxHeight: _bottomPanelSliderHeightOpen,
              minHeight: _bottomPanelSliderHeightClosed,
              parallaxEnabled: false,
              parallaxOffset: .5,
              body: Container(
                child: wGoogleMap(),
              ),
              panelBuilder: (sc) => wBottomPanel(sc),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
            ),
    );
  }

  Widget wBottomPanel(ScrollController sc) {
    return InkWell(
      child: Container(
        decoration: new BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0)),
        ),
        child: Column(
          children: [
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 6.0,
                  ),
                  AppDragCapsule(),
                  SizedBox(
                    height: 6.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: sc,
                padding: EdgeInsets.symmetric(vertical: Dimens.padding),
                children: [
                  //Keterangan Wajib Presensi
                  // _itemContentCustom(title: 'Lokasi', content: 'Lokasi'),

                  if (Application.lokasiPresensiList != null &&
                      Application.lokasiPresensiList.list.length != 0) ...[
                    //Radius
                    wTitle('Radius Presensi',
                        subtitle:
                            'Berikut daftar lokasi presensi berbasis radius'),
                    ...Application.lokasiPresensiList.list
                        .map(
                          (e) => _itemContent(
                              title: e.namaLokasi,
                              content: 'Radius ${e.radius} Meter',
                              lokasiPresensi: e,
                              icon: Icons.location_on_outlined),
                        )
                        .toList(),
                  ],

                  if (Application.kecamatanListModel != null &&
                      Application.kecamatanListModel.rows.length != 0) ...[
                    // Kecamatan
                    wTitle('Kecamatan Presensi',
                        subtitle:
                            'Berikut daftar lokasi presensi berbasis kecamatan'),
                    ...Application.kecamatanListModel.rows
                        .map(
                          (e) => _itemContent2(
                              kecamatan: e,
                              title: e.kabKota,
                              content: e.nama,
                              color: e.color,
                              icon: Icons.location_city),
                        )
                        .toList()
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wTitle(String text, {Widget badge, String subtitle}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.padding, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              if (badge != null) ...[
                SizedBox(width: 10),
                badge,
              ]
            ],
          ),
          if (subtitle != null) ...[
            Text(
              subtitle,
              style: Theme.of(context).textTheme.caption,
            ),
          ]
        ],
      ),
    );
  }

  Widget _itemContent2(
      {String title,
      String content,
      IconData icon,
      Color color,
      @required KecamatanModel kecamatan}) {
    return Container(
      padding: EdgeInsets.only(bottom: Dimens.padding) +
          EdgeInsets.symmetric(horizontal: Dimens.padding),
      child: InkWell(
        onTap: () {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                // bearing: 270.0,
                target: LatLng(
                  double.parse(kecamatan.kordinat[0][0].toString()),
                  double.parse(kecamatan.kordinat[0][1].toString()),
                ),
                // tilt: 30.0,
                zoom: 12.0,
              ),
            ),
          );
        },
        child: Row(
          children: <Widget>[
            Visibility(
              // visible: icon != null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: color.withOpacity(.5)),
                child: Icon(
                  icon ?? Icons.access_time,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title ?? '',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    width: Adapt.screenW() * 0.75,
                    child: Text(
                      content ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wBadge(bool status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
          color: status ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(5)),
      child: Text(status ? 'Wajib' : 'Opsional'),
    );
  }

  Widget _itemContent(
      {String title,
      String content,
      IconData icon,
      Color color,
      @required LokasiPresensiModel lokasiPresensi}) {
    return Container(
      padding: EdgeInsets.only(bottom: Dimens.padding) +
          EdgeInsets.symmetric(horizontal: Dimens.padding),
      child: InkWell(
        onTap: () {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                // bearing: 270.0,
                target: LatLng(
                  double.parse(lokasiPresensi.latitude.toString()),
                  double.parse(lokasiPresensi.longitude.toString()),
                ),
                // tilt: 30.0,
                zoom: 16.0,
              ),
            ),
          );
        },
        child: Row(
          children: <Widget>[
            Visibility(
              // visible: icon != null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).dividerColor),
                child: Icon(
                  icon ?? Icons.access_time,
                  color: color ?? Colors.white,
                  size: 18,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title ?? '',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    width: Adapt.screenW() * 0.75,
                    child: Text(
                      content ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wGoogleMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.location.lat ?? -3.2975608,
            widget.location.long ?? 114.5846911),
        zoom: 14.4746,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
      },
      markers: Set<Marker>.of(_markers.values),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      circles: circles,
      polygons: Set<Polygon>.of(myPolygons),
    );
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(String title) async {
    TextSpan span = new TextSpan(
      style: new TextStyle(
        color: Colors.red,
        fontSize: 35.0,
        fontWeight: FontWeight.bold,
      ),
      text: title,
    );

    TextPainter tp = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.text = TextSpan(
      text: title,
      style: TextStyle(
        fontSize: 35.0,
        color: Theme.of(context).accentColor,
        letterSpacing: 1.0,
        fontFamily: 'Roboto Bold',
      ),
    );

    PictureRecorder recorder = new PictureRecorder();
    Canvas c = new Canvas(recorder);

    tp.layout();
    tp.paint(c, new Offset(20.0, 10.0));

    /* Do your painting of the custom icon here, including drawing text, shapes, etc. */

    Picture p = recorder.endRecording();
    ByteData pngBytes =
        await (await p.toImage(tp.width.toInt() + 40, tp.height.toInt() + 20))
            .toByteData(format: ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes.buffer);

    return BitmapDescriptor.fromBytes(data);
  }
}
