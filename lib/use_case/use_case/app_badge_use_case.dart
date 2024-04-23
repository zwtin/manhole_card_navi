import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/result.dart';
import '/domain/repository/app_badge_repository.dart';
import '/infra/repository_impl/app_badge_repository_impl.dart';

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
