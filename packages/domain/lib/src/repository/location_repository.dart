import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final locationRepositoryProvider = Provider.autoDispose<LocationRepository>(
  (ref) =>
      throw UnimplementedError('locationRepositoryProvider must be overridden'),
);

abstract class LocationRepository {
  Future<Result<void>> requestPermission();

  /// 位置情報の利用が許可されているか（使用中のみ・常に のどちらでもよい）。
  Future<Result<bool>> isPermissionGranted();

  /// 現在地を取得する。許可されていない場合は失敗を返す。
  Future<Result<({double latitude, double longitude})>> getCurrentLocation();
}
