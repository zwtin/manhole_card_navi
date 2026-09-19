import 'dart:async';

import 'package:domain/domain.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl(
    this._platform,
    this._failureRecorder,
  );

  final _logger = Logger();
  final LocationPlatform _platform;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<bool>> requestPermission() {
    return _failureRecorder.guard(
      () async {
        if (!await _platform.isLocationServiceEnabled()) {
          return false;
        }
        var permission = await _platform.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await _platform.requestPermission();
        }
        return _isGranted(permission);
      },
      convert: DomainExceptionConverter.fromPlatform,
    );
  }

  @override
  Future<Result<bool>> isPermissionGranted() {
    return _failureRecorder.guard(
      () async => _isGranted(await _platform.checkPermission()),
      convert: DomainExceptionConverter.fromPlatform,
    );
  }

  @override
  Future<Result<Coordinate?>> getCurrentLocation() {
    return _failureRecorder.guard(
      () async {
        try {
          final position = await _platform.getCurrentPosition();
          return Coordinate(
            latitude: position.latitude,
            longitude: position.longitude,
          );
        } on LocationServiceDisabledException {
          // 端末の位置情報がオフ。利用者が選んだ状態なので失敗にしない。
          return null;
        } on PermissionDeniedException {
          return null;
        }
      },
      convert: (error, stackTrace) => error is TimeoutException
          ? TimedOutException(cause: error, stackTrace: stackTrace)
          : DomainExceptionConverter.fromPlatform(error, stackTrace),
    );
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

/// 端末の位置情報（geolocator）。static な API を、テストで差し替えられるように包む。
class LocationPlatform {
  const LocationPlatform();

  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition();
}
