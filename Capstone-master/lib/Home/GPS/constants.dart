import 'package:google_maps_flutter/google_maps_flutter.dart';

final String baseUrl =
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
const String API_KEY = 'AIzaSyDaQrL9-rpcDB6Zkime5i1qrZ8U6XVq7eU';
const places = [
  {'id': '1', 'placeName': '동물병원'},
  {'id': '2', 'placeName': '애견샵'},
];

final initialLocation = CameraPosition(
  target: LatLng(37.39096, 126.91920),
  zoom: 14,
);