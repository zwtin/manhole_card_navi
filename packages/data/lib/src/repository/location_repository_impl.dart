import 'package:domain/domain.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class LocationRepositoryImpl implements LocationRepository {
  final _logger = Logger();

  @override
  Future<Result<void>> requestPermission() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        throw const CustomException(
          title: 'エラー',
          text: '位置情報が取得できないデバイスです。',
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const CustomException(
            title: 'エラー',
            text: '位置情報のアクセスを許可してください。',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const CustomException(
          title: 'エラー',
          text: '位置情報のアクセスを許可してください。',
        );
      }

      return const Result.success(null);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '位置情報にアクセスできませんでした。',
        ),
      );
    }
  }

  @override
  Future<Result<bool>> isPermissionGranted() async {
    try {
      final permission = await Geolocator.checkPermission();
      return Result.success(
        permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '位置情報にアクセスできませんでした。',
        ),
      );
    }
  }

  @override
  Future<Result<({double latitude, double longitude})>>
      getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      return Result.success(
        (latitude: position.latitude, longitude: position.longitude),
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '現在地を取得できませんでした。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('LocationRepositoryImpl dispose');
  }
}
