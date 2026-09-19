import 'package:geolocator/geolocator.dart';

/// 端末の位置情報（geolocator）。static な API を、テストで差し替えられるように包む。
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
