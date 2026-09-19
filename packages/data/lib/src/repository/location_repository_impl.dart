import 'dart:async';

import 'package:domain/domain.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../datasource/failure_recorder.dart';
import '../datasource/location_data_source.dart';
import '../mapper/domain_exception_mapper.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl(
    this._location,
    this._failureRecorder,
  );

  final _logger = Logger();
  final LocationDataSource _location;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<bool>> requestPermission() {
    return _failureRecorder.guard(
      () async {
        if (!await _location.isLocationServiceEnabled()) {
          return false;
        }
        var permission = await _location.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await _location.requestPermission();
        }
        return _isGranted(permission);
      },
      convert: DomainExceptionMapper.fromPlatform,
    );
  }

  @override
  Future<Result<bool>> isPermissionGranted() {
    return _failureRecorder.guard(
      () async => _isGranted(await _location.checkPermission()),
      convert: DomainExceptionMapper.fromPlatform,
    );
  }

  @override
  Future<Result<Coordinate?>> getCurrentLocation() {
    return _failureRecorder.guard(
      () async {
        try {
          final position = await _location.getCurrentPosition();
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
          : DomainExceptionMapper.fromPlatform(error, stackTrace),
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
