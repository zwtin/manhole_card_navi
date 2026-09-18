import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';
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
          .getString(_searchConditionKey, defaultValue: '')
          .getValue();
      return Result.success(SearchConditionJsonMapper.fromJsonString(source));
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  @override
  Stream<SearchCondition> getStream() {
    return _instance
        .getString(_searchConditionKey, defaultValue: '')
        .map(SearchConditionJsonMapper.fromJsonString);
  }

  void dispose() {
    _logger.d('SearchConditionQueryServiceImpl dispose');
  }
}
