import 'package:domain/domain.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  final _logger = Logger();

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) async {
    try {
      FlutterAppBadgeControl.updateBadgeCount(count);
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> remove() async {
    try {
      FlutterAppBadgeControl.removeBadge();
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
      );
    }
  }

  void dispose() {
    _logger.d('AppBadgeRepositoryImpl dispose');
  }
}
