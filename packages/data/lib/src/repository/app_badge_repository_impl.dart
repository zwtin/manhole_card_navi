import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';

import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  AppBadgeRepositoryImpl(
    this._failureRecorder,
  );

  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) {
    return _failureRecorder.guard(
      () => FlutterAppBadgeControl.updateBadgeCount(count),
      convert: DomainExceptionMapper.fromPlatform,
    );
  }

  @override
  Future<Result<void>> remove() {
    return _failureRecorder.guard(
      FlutterAppBadgeControl.removeBadge,
      convert: DomainExceptionMapper.fromPlatform,
    );
  }
}
