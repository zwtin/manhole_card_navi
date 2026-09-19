import 'package:domain/domain.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  final _logger = Logger();
  final _failureRecorder = FailureRecorder();

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) async {
    try {
      await FlutterAppBadgeControl.updateBadgeCount(count);
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> remove() async {
    try {
      await FlutterAppBadgeControl.removeBadge();
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
        stackTrace,
      );
    }
  }

  void dispose() {
    _logger.d('AppBadgeRepositoryImpl dispose');
  }
}
