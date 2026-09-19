import 'package:domain/domain.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  AppBadgeRepositoryImpl(
    this._failureRecorder,
  );

  final _logger = Logger();
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) {
    return _failureRecorder.guard(
      () => FlutterAppBadgeControl.updateBadgeCount(count),
      convert: DomainExceptionConverter.fromPlatform,
    );
  }

  @override
  Future<Result<void>> remove() {
    return _failureRecorder.guard(
      FlutterAppBadgeControl.removeBadge,
      convert: DomainExceptionConverter.fromPlatform,
    );
  }

  void dispose() {
    _logger.d('AppBadgeRepositoryImpl dispose');
  }
}
