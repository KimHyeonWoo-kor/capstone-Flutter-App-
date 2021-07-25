import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

import 'location_service.dart';

class MapNotifier extends ChangeNotifier {

  final locationService = LocationService();
  GoogleMapController googleMapController;

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  Future<void> subscribeToLocation() async {

    Uint8List iconData = await _getMarker();
    locationService.trackLocation((newLocation) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(newLocation.latitude, newLocation.longitude),
            tilt: 0,
            zoom: 18,
          ),
        ),
      );
      _updateMarkerAndCircle(newLocation, iconData);
    });
  }

  Future<Uint8List> _getMarker() async {
    ByteData byteData = await rootBundle.load("assets/dog_icon.png");
    return byteData.buffer.asUint8List();
  }

  void _updateMarkerAndCircle(LocationData userLocation, Uint8List iconData) {
    LatLng position = LatLng(userLocation.latitude, userLocation.longitude);
    Marker locationMarker = Marker(
      markerId: MarkerId("home"),
      position: position,
      rotation: userLocation.heading,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      icon: BitmapDescriptor.fromBytes(iconData),
    );
    Circle locationCircle = Circle(
      circleId: CircleId("dog"),
      radius: userLocation.accuracy,
      zIndex: 1,
      strokeColor: Colors.blue,
      center: position,
      fillColor: Colors.blue.withAlpha(70),
    );
    markers.clear();
    circles.clear();
    markers.add(locationMarker);
    circles.add(locationCircle);
    notifyListeners();
  }

  @override
  void dispose() {
    locationService.dispose();
    super.dispose();
  }
}
