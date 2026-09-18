import 'dart:async';

import 'package:domain/domain.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';

class LocationRepositoryImpl implements LocationRepository {
  final _logger = Logger();

  @override
  Future<Result<bool>> requestPermission() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const Result.success(false);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return Result.success(_isGranted(permission));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<bool>> isPermissionGranted() async {
    try {
      return Result.success(_isGranted(await Geolocator.checkPermission()));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
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
    } on TimeoutException catch (error, stackTrace) {
      return Result.failure(
        TimedOutException(cause: error, stackTrace: stackTrace),
      );
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
      );
    }
  }

  /// 使用中のみ・常に のどちらでも許可とみなす。
  static bool _isGranted(LocationPermission permission) {
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  void dispose() {
    _logger.d('LocationRepositoryImpl dispose');
  }
}
