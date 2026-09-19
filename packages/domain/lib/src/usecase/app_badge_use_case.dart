import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/repository/app_badge_repository.dart';

final appBadgeUseCaseProvider = Provider<AppBadgeUseCase>(
  (ref) => AppBadgeUseCase(
    ref.watch(appBadgeRepositoryProvider),
  ),
);

class AppBadgeUseCase {
  AppBadgeUseCase(
    this._appBadgeRepository,
  );

  final AppBadgeRepository _appBadgeRepository;

  Future<Result<void>> updateCount({
    required int count,
  }) async {
    return _appBadgeRepository.updateCount(count: count);
  }

  Future<Result<void>> remove() async {
    return _appBadgeRepository.remove();
  }
}
