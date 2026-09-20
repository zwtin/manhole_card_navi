import 'package:data/src/datasource/app_badge_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/repository/failure_recorder.dart';
import 'package:domain/domain.dart';

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  AppBadgeRepositoryImpl(
    this._appBadge,
    this._failureRecorder,
  );

  final AppBadgeDataSource _appBadge;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) {
    return _failureRecorder.guard(
      () => _appBadge.updateCount(count),
      convert: DomainExceptionMapper.fromPlatform,
    );
  }

  @override
  Future<Result<void>> remove() {
    return _failureRecorder.guard(
      _appBadge.remove,
      convert: DomainExceptionMapper.fromPlatform,
    );
  }
}
