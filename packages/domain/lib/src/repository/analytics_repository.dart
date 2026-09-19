import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/analytics_event.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final analyticsRepositoryProvider = Provider<AnalyticsRepository>(
  (ref) =>
      throw UnimplementedError(
        'analyticsRepositoryProvider must be overridden',
      ),
);

abstract class AnalyticsRepository {
  Future<Result<void>> sendAppOpen();
  Future<Result<void>> sendEvent({required AnalyticsEvent analyticsEvent});
}
