import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../mapper/search_condition_json_mapper.dart';

/// 検索条件を端末保存するキー。
const _searchConditionKey = 'search_condition';

class SearchConditionRepositoryImpl implements SearchConditionRepository {
  SearchConditionRepositoryImpl(
    this._instance,
  );

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<void>> save({
    required SearchCondition searchCondition,
  }) async {
    try {
      final result = await _instance.setString(
        _searchConditionKey,
        SearchConditionJsonMapper.toJsonString(searchCondition),
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
          text: '検索条件の保存に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('SearchConditionRepositoryImpl dispose');
  }
}
