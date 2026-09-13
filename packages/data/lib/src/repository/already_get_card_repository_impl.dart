import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AlreadyGetCardRepositoryImpl implements AlreadyGetCardRepository {
  AlreadyGetCardRepositoryImpl(
    this._instance,
  );

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<void>> save({
    required ManholeCard manholeCard,
  }) async {
    try {
      final list = _instance.getStringList(
        'already_get_cards',
        defaultValue: [],
      ).getValue();
      if (!list.contains(manholeCard.id)) {
        list.add(manholeCard.id);
      }
      final result = await _instance.setStringList(
        'already_get_cards',
        list,
      );
      if (result) {
        return const Result.success(null);
      } else {
        throw const CustomException(
          title: 'エラー',
          text: 'データの更新に失敗しました。',
        );
      }
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '取得済みカードの保存に失敗しました。',
        ),
      );
    }
  }

  @override
  Future<Result<void>> delete({
    required ManholeCard manholeCard,
  }) async {
    try {
      final list = _instance.getStringList(
        'already_get_cards',
        defaultValue: [],
      ).getValue();
      if (list.contains(manholeCard.id)) {
        list.remove(manholeCard.id);
      }
      final result = await _instance.setStringList(
        'already_get_cards',
        list,
      );
      if (result) {
        return const Result.success(null);
      } else {
        throw const CustomException(
          title: 'エラー',
          text: 'データの更新に失敗しました。',
        );
      }
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '取得済みカードの削除に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('AlreadyGetCardRepositoryImpl dispose');
  }
}
