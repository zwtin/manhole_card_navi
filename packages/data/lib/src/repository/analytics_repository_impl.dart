import 'package:logger/logger.dart';

import 'package:data/src/datasource/analytics_data_source.dart';
import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/mapper/analytics_event_mapper.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(
    this._analytics,
    this._crashlytics,
  );

  final _logger = Logger();
  final AnalyticsDataSource _analytics;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<void>> send({required AnalyticsEvent event}) async {
    try {
      await _analytics.send(AnalyticsEventMapper.toModel(event));
      _logger.d('$event');
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }
}
