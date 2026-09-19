import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../entity/app_info.dart';
import '../repository/app_info_repository.dart';

/// UseCase は状態を持たないので、画面ごとに分けずアプリ全体で 1 つ。
final appInfoUseCaseProvider = Provider<AppInfoUseCase>(
  (ref) {
    final appInfoUseCase = AppInfoUseCase(
      ref.watch(appInfoRepositoryProvider),
    );
    ref.onDispose(appInfoUseCase.dispose);
    return appInfoUseCase;
  },
);

class AppInfoUseCase {
  AppInfoUseCase(
    this._appInfoRepository,
  );

  final AppInfoRepository _appInfoRepository;

  final _logger = Logger();

  Future<Result<AppInfo>> get() {
    return _appInfoRepository.getAppInfo();
  }

  void dispose() {
    _logger.d('AppInfoUseCase dispose');
  }
}
