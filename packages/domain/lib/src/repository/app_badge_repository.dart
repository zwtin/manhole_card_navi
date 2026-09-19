import 'package:riverpod/riverpod.dart';

import '../core/result.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final appBadgeRepositoryProvider = Provider<AppBadgeRepository>(
  (ref) =>
      throw UnimplementedError('appBadgeRepositoryProvider must be overridden'),
);

abstract class AppBadgeRepository {
  Future<Result<void>> updateCount({required int count});
  Future<Result<void>> remove();
}
