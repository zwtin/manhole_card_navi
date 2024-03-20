import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/domain/repository/app_badge_repository.dart';

final appBadgeRepositoryProvider = Provider.autoDispose<AppBadgeRepository>(
  (ref) {
    final appBadgeRepository = AppBadgeRepositoryImpl();
    ref.onDispose(appBadgeRepository.dispose);
    return appBadgeRepository;
  },
);

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  final _logger = Logger();

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) async {
    try {
      FlutterAppBadger.updateBadgeCount(count);
      return const Result.success(null);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'バッジの更新に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<void>> remove() async {
    try {
      FlutterAppBadger.removeBadge();
      return const Result.success(null);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'バッジの削除に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('AppBadgeRepositoryImpl dispose');
  }
}
