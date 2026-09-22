import 'package:data/src/datasource/app_badge_data_source.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  AppBadgeRepositoryImpl(
    this._appBadge,
    this._crashlytics,
  );

  final AppBadgeDataSource _appBadge;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) async {
    try {
      await _appBadge.updateCount(count);
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<void>> remove() async {
    try {
      await _appBadge.remove();
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }
}
