import '/domain/entity/analytics_event.dart';
import '/domain/entity/result.dart';

abstract class AnalyticsRepository {
  Future<Result<void>> sendAppOpen();
  Future<Result<void>> sendEvent({
    required AnalyticsEvent analyticsEvent,
  });
}
