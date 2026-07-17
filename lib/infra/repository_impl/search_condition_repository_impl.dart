import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/domain/entity/search_condition.dart';
import '/domain/repository/search_condition_repository.dart';
import '/infra/mapper/search_condition_json_mapper.dart';
import '/temporary_provider.dart';

/// 検索条件を端末保存するキー。
const _searchConditionKey = 'search_condition';

final searchConditionRepositoryProvider =
    Provider.autoDispose<SearchConditionRepository>(
  (ref) {
    final searchConditionRepository = SearchConditionRepositoryImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(searchConditionRepository.dispose);
    return searchConditionRepository;
  },
);

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
