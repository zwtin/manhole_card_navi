import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final appBadgeRepositoryProvider = Provider.autoDispose<AppBadgeRepository>(
  (ref) =>
      throw UnimplementedError('appBadgeRepositoryProvider must be overridden'),
);

abstract class AppBadgeRepository {
  Future<Result<void>> updateCount({required int count});
  Future<Result<void>> remove();
}
