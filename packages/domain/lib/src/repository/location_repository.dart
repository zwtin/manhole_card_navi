import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/coordinate.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final locationRepositoryProvider = Provider.autoDispose<LocationRepository>(
  (ref) =>
      throw UnimplementedError('locationRepositoryProvider must be overridden'),
);

abstract class LocationRepository {
  /// 位置情報の利用許可を求める。許可されたら true、拒否された・端末の位置情報が
  /// オフなら false（失敗ではない）。
  Future<Result<bool>> requestPermission();

  /// 位置情報の利用が許可されているか（使用中のみ・常に のどちらでもよい）。
  Future<Result<bool>> isPermissionGranted();

  /// 現在地を取得する。端末の位置情報がオフ・許可されていないときは null
  /// （失敗ではない）。
  Future<Result<Coordinate?>> getCurrentLocation();
}
