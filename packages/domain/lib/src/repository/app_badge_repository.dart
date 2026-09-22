import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';

final appBadgeRepositoryProvider = Provider<AppBadgeRepository>(
  (ref) =>
      throw UnimplementedError('appBadgeRepositoryProvider must be overridden'),
);

abstract class AppBadgeRepository {
  Future<Result<void>> updateCount({required int count});
  Future<Result<void>> remove();
}
