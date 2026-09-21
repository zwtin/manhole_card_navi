import 'package:logger/logger.dart';

import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/mapper/analytics_event_mapper.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/repository/failure_recorder.dart';
import 'package:domain/domain.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(
    this._analytics,
    this._failureRecorder,
  );

  final _logger = Logger();
  final AnalyticsDataSource _analytics;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> send({required AnalyticsEvent event}) {
    return _failureRecorder.guard(
      () async {
        await _analytics.send(AnalyticsEventMapper.toModel(event));
        _logger.d('$event');
      },
      convert: DomainExceptionMapper.fromPlatform,
    );
  }
}
