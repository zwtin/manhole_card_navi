import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/analytics_event.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>(
  (ref) =>
      throw UnimplementedError(
        'analyticsRepositoryProvider must be overridden',
      ),
);

abstract class AnalyticsRepository {
  Future<Result<void>> send({required AnalyticsEvent event});
}
