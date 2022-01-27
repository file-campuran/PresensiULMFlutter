import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/configs/config.dart';

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

  @override
  void initState() {
    _onLoadMap();
    super.initState();
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

    /* List<Map<String, dynamic>> blueZoneExample = [
      {
        'name': 'UNLAM BJB',
        'latitude': -3.4448526,
        'longitude': 114.8418003,
        'radius': 500,
      },
      {
        'name': 'UNLAM BJM',
        'latitude': -3.2975608,
        'longitude': 114.5846911,
        'radius': 800,
      },
    ]; */
    myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(100, 2)),
        'assets/images/lokasi_presensi80.png');
    if (widget.withBlueZone) {
      for (var item in Application.lokasiPresensiList.list ?? []) {
        circle.add(Circle(
          strokeWidth: 0,
          fillColor: Color.fromRGBO(0, 100, 255, 0.2),
          circleId: CircleId(item.id),
          center: LatLng(item.latitude, item.longitude),
          radius: item.radius,
        ));

        final lokasiMarkerPresensi = MarkerId(item.id);
        UtilLogger.log('MARKER ID', lokasiMarkerPresensi);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title == null
          ? null
          : AppCustomAppBar.defaultAppBar(
              title: Translate.of(context).translate('location'),
              context: context),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.location.lat ?? -3.2975608,
                widget.location.long ?? 114.5846911),
            zoom: 14.4746,
          ),
          markers: Set<Marker>.of(_markers.values),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          circles: circles,
        ),
      ),
    );
  }
}
