import 'package:domain/domain.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

import '../datasource/failure_recorder.dart';
import '../mapper/domain_exception_mapper.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(
    this._analytics,
    this._failureRecorder,
  );

  final _logger = Logger();
  final FirebaseAnalytics _analytics;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> send({required AnalyticsEvent event}) {
    return _failureRecorder.guard(
      () async {
        switch (event) {
          case AppOpen():
            await _analytics.logAppOpen();
          case ScreenView(:final screenName, :final parameters):
            await _analytics.logEvent(
              name: 'screen_pv',
              parameters: {'screen_name': screenName, ...parameters},
            );
        }
        _logger.d('$event');
      },
      convert: DomainExceptionMapper.fromPlatform,
    );
  }

  void dispose() {
    _logger.d('AnalyticsRepositoryImpl dispose');
  }
}
