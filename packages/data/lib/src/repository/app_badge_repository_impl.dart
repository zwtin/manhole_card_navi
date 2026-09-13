import 'package:domain/domain.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:logger/logger.dart';

class AppBadgeRepositoryImpl implements AppBadgeRepository {
  final _logger = Logger();

  @override
  Future<Result<void>> updateCount({
    required int count,
  }) async {
    try {
      FlutterAppBadgeControl.updateBadgeCount(count);
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
      FlutterAppBadgeControl.removeBadge();
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
