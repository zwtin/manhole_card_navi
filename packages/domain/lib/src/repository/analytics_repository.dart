import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/analytics_event.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final analyticsRepositoryProvider = Provider.autoDispose<AnalyticsRepository>(
  (ref) =>
      throw UnimplementedError(
        'analyticsRepositoryProvider must be overridden',
      ),
);

abstract class AnalyticsRepository {
  Future<Result<void>> sendAppOpen();
  Future<Result<void>> sendEvent({required AnalyticsEvent analyticsEvent});
}
