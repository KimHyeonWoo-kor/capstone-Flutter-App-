import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

typedef TraceCallback(newLocation);

class LocationService {
  final locationTracker = Location();
  StreamSubscription locationSubscription;

  Future<void> getCurrentLocation() async {

    bool locationPermissionGranted = await _checkLocationPermission();
    if (locationPermissionGranted) {
      await locationTracker.getLocation();
    } else {
      debugPrint("location permission denied");
    }
  }

  void trackLocation(TraceCallback callBack) {
    if (locationSubscription != null) {
      locationSubscription.cancel();
    }
    locationSubscription = locationTracker.onLocationChanged.listen(
      (newLocation) => callBack(newLocation),
    );
  }

  Future<bool> _checkLocationPermission() async {
    var locationPermission = await locationTracker.hasPermission();
    if (locationPermission != PermissionStatus.granted) {
      var permissionResult = await locationTracker.requestPermission();
      if (permissionResult == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  void dispose() => locationSubscription.cancel();
}
