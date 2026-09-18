import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final _logger = Logger();
  final _failureRecorder = FailureRecorder();
  final _analytics = FirebaseAnalytics.instance;

  @override
  Future<Result<void>> sendEvent({
    required AnalyticsEvent analyticsEvent,
  }) async {
    try {
      await _analytics.logEvent(
        name: analyticsEvent.name,
        parameters: analyticsEvent.parameters,
      );
      _logger.d('${analyticsEvent.name} ${analyticsEvent.parameters}');
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> sendAppOpen() async {
    try {
      await _analytics.logAppOpen();
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
        stackTrace,
      );
    }
  }

  void dispose() {
    _logger.d('AnalyticsRepositoryImpl dispose');
  }
}
