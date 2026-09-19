import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/analytics_event.dart';
import 'package:domain/src/repository/analytics_repository.dart';

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
