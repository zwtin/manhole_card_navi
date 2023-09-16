import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/analytics_event.dart';
import '/domain/entity/result.dart';
import '/domain/repository/analytics_repository.dart';
import '/flavors.dart';

final analyticsRepositoryProvider = Provider.autoDispose<AnalyticsRepository>(
  (ref) {
    final analyticsRepository = AnalyticsRepositoryImpl();
    ref.onDispose(analyticsRepository.dispose);
    return analyticsRepository;
  },
);

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final _logger = Logger();
  final _analytics = FirebaseAnalytics.instance;

  @override
  Future<Result<void>> sendEvent({required AnalyticsEvent event}) async {
    try {
      if (F.appFlavor == Flavor.development) {
        await _analytics.logEvent(
          name: event.name,
          parameters: event.parameters,
        );
      }
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('AnalyticsRepositoryImpl dispose');
  }
}
