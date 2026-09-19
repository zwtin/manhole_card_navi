import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/analytics_event.dart';
import '../repository/analytics_repository.dart';

/// UseCase は状態を持たないので、画面ごとに分けずアプリ全体で 1 つ。
final analyticsUseCaseProvider = Provider<AnalyticsUseCase>(
  (ref) {
    final analyticsUseCase = AnalyticsUseCase(
      ref.watch(analyticsRepositoryProvider),
    );
    ref.onDispose(analyticsUseCase.dispose);
    return analyticsUseCase;
  },
);

class AnalyticsUseCase {
  AnalyticsUseCase(
    this._analyticsRepository,
  );

  final AnalyticsRepository _analyticsRepository;

  final _logger = Logger();

  Future<Result<void>> send({required AnalyticsEvent event}) {
    return _analyticsRepository.send(event: event);
  }

  void dispose() {
    _logger.d('AnalyticsUseCase dispose');
  }
}
