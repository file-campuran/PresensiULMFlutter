import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:absen_online/api/geocoder_repository.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/utils/utils.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Completer<GoogleMapController> _controller = Completer();

  Map<String, Marker> markers = <String, Marker>{};
  LatLng _currentPosition = LatLng(-6.902735, 107.618782);

  String primaryAddress = '';
  String secondaryAddress = '';
  String address = '';
  bool isLoading = true;

  @override
  void initState() {
    _initializeLocation();
    markers["new"] = Marker(
      markerId: MarkerId("Bandung"),
      position: _currentPosition,
      icon: BitmapDescriptor.defaultMarker,
    );
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) async {
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 15.5),
      ),
    );

    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomAppBar.defaultAppBar(
          title: Translate.of(context).translate('select_location'),
          context: context),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16.0,
            ),
            markers: Set<Marker>.of(markers.values),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onCameraMove: _updatePosition,
            onCameraIdle: _cameraIdle,
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: EdgeInsets.all(0.0),
                elevation: 5.0,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLocation(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
                        child: AppButton(
                          onPressed: () {
                            Navigator.pop(context, address);
                          },
                          text: Translate.of(context)
                              .translate('select_location'),
                          disableTouchWhenLoading: true,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildLocation() {
    return Row(
      children: <Widget>[
        Icon(Icons.location_on, color: Colors.red),
        SizedBox(width: 14),
        if (isLoading) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeleton(
                height: 10,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              SizedBox(height: 5),
              AppSkeleton(
                height: 10,
                width: MediaQuery.of(context).size.width * 0.5,
              )
            ],
          )
        ] else ...[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              address,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]
      ],
    );
  }

  void _updatePosition(CameraPosition _position) async {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    Marker marker = markers["new"];

    setState(() {
      markers["new"] = marker.copyWith(
          positionParam:
              LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
      _currentPosition =
          LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude);
    });
  }

  _cameraIdle() async {
    setState(() {
      isLoading = true;
    });
    address = await GeocoderRepository().getAddress(
        latitude: _currentPosition.latitude,
        longitude: _currentPosition.longitude);
    // await Future.delayed(Duration(seconds: 2));
    // address = 'tes';
    setState(() {
      isLoading = false;
    });
  }

  void _initializeLocation() async {
    final GoogleMapController controller = await _controller.future;
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocation, zoom: 15.5),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
