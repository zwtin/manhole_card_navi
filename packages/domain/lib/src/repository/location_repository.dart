import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/coordinate.dart';

final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) =>
      throw UnimplementedError('locationRepositoryProvider must be overridden'),
);

abstract class LocationRepository {
  /// 拒否された・端末の位置情報がオフのときは false（失敗ではない）。
  Future<Result<bool>> requestPermission();

  /// 使用中のみ・常に のどちらの許可でも true。
  Future<Result<bool>> isPermissionGranted();

  /// 端末の位置情報がオフ・許可されていないときは null（失敗ではない）。
  Future<Result<Coordinate?>> getCurrentLocation();
}
