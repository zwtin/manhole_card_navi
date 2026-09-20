import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

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
}
