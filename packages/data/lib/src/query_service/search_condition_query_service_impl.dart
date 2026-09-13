import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../mapper/search_condition_json_mapper.dart';

/// 検索条件を端末保存するキー。
const _searchConditionKey = 'search_condition';

class SearchConditionQueryServiceImpl implements SearchConditionQueryService {
  SearchConditionQueryServiceImpl(
    this._instance,
  );

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<SearchCondition>> get() async {
    try {
      final source = _instance
          .getString(
            _searchConditionKey,
            defaultValue: '',
          )
          .getValue();
      return Result.success(
        SearchConditionJsonMapper.fromJsonString(source),
      );
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '検索条件の取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Stream<SearchCondition> getStream() {
    return _instance
        .getString(
          _searchConditionKey,
          defaultValue: '',
        )
        .map(SearchConditionJsonMapper.fromJsonString);
  }

  void dispose() {
    _logger.d('SearchConditionQueryServiceImpl dispose');
  }
}
