import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../entity/result.dart';
import '../repository/app_badge_repository.dart';

final appBadgeUseCaseProvider = Provider.autoDispose<AppBadgeUseCase>(
  (ref) {
    final appBadgeUseCase = AppBadgeUseCase(
      ref.watch(appBadgeRepositoryProvider),
    );
    ref.onDispose(appBadgeUseCase.dispose);
    return appBadgeUseCase;
  },
);

class AppBadgeUseCase {
  AppBadgeUseCase(
    this._appBadgeRepository,
  );

  final AppBadgeRepository _appBadgeRepository;

  final _logger = Logger();

  Future<Result<void>> updateCount({
    required int count,
  }) async {
    return _appBadgeRepository.updateCount(count: count);
  }

  Future<Result<void>> remove() async {
    return _appBadgeRepository.remove();
  }

  void dispose() {
    _logger.d('AppBadgeUseCase dispose');
  }
}
