import 'package:geolocator/geolocator.dart';

class LocationDataSource {
  const LocationDataSource();

  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition();
}
