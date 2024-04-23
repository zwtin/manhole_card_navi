import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/analytics_event.dart';
import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/domain/repository/analytics_repository.dart';

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
  Future<Result<void>> sendEvent({
    required AnalyticsEvent analyticsEvent,
  }) async {
    try {
      await _analytics.logEvent(
        name: analyticsEvent.name,
        parameters: analyticsEvent.parameters,
      );
      _logger.d('${analyticsEvent.name} ${analyticsEvent.parameters}');
      return const Result.success(null);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'イベントの送信に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<void>> sendAppOpen() async {
    try {
      _analytics.logAppOpen();
      return const Result.success(null);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'アプリ起動イベントの送信に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('AnalyticsRepositoryImpl dispose');
  }
}
