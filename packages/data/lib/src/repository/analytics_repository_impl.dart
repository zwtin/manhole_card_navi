import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(
    this._analytics,
    this._failureRecorder,
  );

  final _logger = Logger();
  final FirebaseAnalytics _analytics;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> sendEvent({
    required AnalyticsEvent analyticsEvent,
  }) {
    return _failureRecorder.guard(
      () async {
        await _analytics.logEvent(
          name: analyticsEvent.name,
          parameters: analyticsEvent.parameters,
        );
        _logger.d('${analyticsEvent.name} ${analyticsEvent.parameters}');
      },
      convert: DomainExceptionConverter.fromPlatform,
    );
  }

  @override
  Future<Result<void>> sendAppOpen() {
    return _failureRecorder.guard(
      _analytics.logAppOpen,
      convert: DomainExceptionConverter.fromPlatform,
    );
  }

  void dispose() {
    _logger.d('AnalyticsRepositoryImpl dispose');
  }
}
