import 'package:geolocator/geolocator.dart';

class LocationDataSource {
  const LocationDataSource();

  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  /// 使用中のみ・常に のどちらの許可でも true。
  Future<bool> isPermissionGranted() async {
    return _isGranted(await Geolocator.checkPermission());
  }

  /// まだ決めていないときだけ利用者に尋ねる。返すのは [isPermissionGranted] と
  /// 同じ意味。
  Future<bool> requestPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return _isGranted(permission);
  }

  Future<({double latitude, double longitude})> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    return (latitude: position.latitude, longitude: position.longitude);
  }

  static bool _isGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}
