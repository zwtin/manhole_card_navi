import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/entity/analytics_event.dart';
import 'package:domain/src/repository/analytics_repository.dart';

final analyticsUseCaseProvider = Provider<AnalyticsUseCase>(
  (ref) => AnalyticsUseCase(
    ref.watch(analyticsRepositoryProvider),
  ),
);

class AnalyticsUseCase {
  AnalyticsUseCase(
    this._analyticsRepository,
  );

  final AnalyticsRepository _analyticsRepository;

  Future<Result<void>> send({required AnalyticsEvent event}) {
    return _analyticsRepository.send(event: event);
  }
}
