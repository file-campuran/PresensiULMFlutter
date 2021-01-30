import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';

class Location extends StatefulWidget {
  final LocationModel location;
  final bool withBlueZone;

  Location({Key key, this.location, this.withBlueZone = true})
      : super(key: key);

  @override
  _LocationState createState() {
    return _LocationState();
  }
}

class _LocationState extends State<Location> {
  CameraPosition _initPosition;
  Set<Circle> circles;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    _onLoadMap();
    super.initState();
  }

  ///On load map
  void _onLoadMap() {
    List<Circle> circle = [];
    final MarkerId markerId = MarkerId(widget.location.id.toString());
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(widget.location.lat, widget.location.long),
      infoWindow: InfoWindow(title: widget.location.name),
      onTap: () {},
    );

    List<Map<String, dynamic>> blueZoneExample = [
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
    ];

    if (widget.withBlueZone) {
      for (var item in Application.remoteConfig.application.presensi.zone) {
        circle.add(Circle(
          strokeWidth: 0,
          fillColor: Color.fromRGBO(0, 100, 255, 0.2),
          circleId: CircleId('1'),
          center: LatLng(item.latitude, item.longitude),
          radius: double.parse(item.radius.toString()),
        ));
      }

      circles = Set.from(circle);
    }

    setState(() {
      _initPosition = CameraPosition(
        target: LatLng(widget.location.lat, widget.location.long),
        zoom: 14.4746,
      );
      _markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('location'),
        ),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: _initPosition,
          markers: Set<Marker>.of(_markers.values),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          circles: circles,
        ),
      ),
    );
  }
}
