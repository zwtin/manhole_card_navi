import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/analytics_event.dart';
import '/domain/entity/result.dart';
import '/domain/repository/analytics_repository.dart';
import '/infra/repository_impl/analytics_repository_impl.dart';

final analyticsUseCaseProvider = Provider.autoDispose<AnalyticsUseCase>(
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

  Future<Result<void>> send({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    final event = AnalyticsEvent(name: name, parameters: parameters);
    return _analyticsRepository.sendEvent(event: event);
  }

  void dispose() {
    _logger.d('AnalyticsUseCase dispose');
  }
}
