import '/domain/entity/result.dart';

abstract class AppBadgeRepository {
  Future<Result<void>> updateCount({
    required int count,
  });
  Future<Result<void>> remove();
}
