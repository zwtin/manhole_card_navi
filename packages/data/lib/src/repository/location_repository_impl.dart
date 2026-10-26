import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/location_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl(this._location, this._crashlytics);

  final LocationDataSource _location;
  final CrashlyticsDataSource _crashlytics;
  final _permissionGranted = StreamController<bool>.broadcast();

  @override
  Future<Result<bool>> requestPermission() async {
    try {
      final granted =
          await _location.isLocationServiceEnabled() &&
          await _location.requestPermission();
      _permissionGranted.add(granted);
      return Result.success(granted);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Stream<bool> watchPermissionGranted() => _permissionGranted.stream;

  @override
  Future<Result<bool>> isPermissionGranted() async {
    try {
      return Result.success(await _location.isPermissionGranted());
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<Coordinate?>> getCurrentLocation() async {
    try {
      final position = await _location.getCurrentPosition();
      return Result.success(
        Coordinate(latitude: position.latitude, longitude: position.longitude),
      );
    } on LocationServiceDisabledException {
      // 利用者が選んだ状態なので失敗にしない。
      return const Result.success(null);
    } on PermissionDeniedException {
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  Future<void> dispose() => _permissionGranted.close();
}
