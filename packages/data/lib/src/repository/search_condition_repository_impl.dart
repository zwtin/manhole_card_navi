import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';
import '../mapper/search_condition_json_mapper.dart';
import '../service/failure_recorder.dart';

class SearchConditionRepositoryImpl implements SearchConditionRepository {
  SearchConditionRepositoryImpl(
    this._preferences,
    this._failureRecorder,
  );

  /// 検索条件を保存する SharedPreferences のキー。
  static const _key = 'search_condition';

  final _logger = Logger();
  final StreamingSharedPreferences _preferences;
  final FailureRecorder _failureRecorder;

  Preference<String> get _source =>
      _preferences.getString(_key, defaultValue: '');

  @override
  Future<Result<SearchCondition>> get() {
    return _failureRecorder.guard(
      () async => SearchConditionJsonMapper.fromJsonString(_source.getValue()),
      convert: DomainExceptionConverter.fromLocalStorage,
    );
  }

  @override
  Stream<SearchCondition> getStream() {
    return _source.map(SearchConditionJsonMapper.fromJsonString);
  }

  @override
  Future<Result<void>> save({
    required SearchCondition searchCondition,
  }) {
    return _failureRecorder.guard(
      () async {
        final saved = await _preferences.setString(
          _key,
          SearchConditionJsonMapper.toJsonString(searchCondition),
        );
        if (!saved) {
          throw const PersistenceException(detail: '検索条件を保存できませんでした');
        }
      },
      convert: DomainExceptionConverter.fromLocalStorage,
    );
  }

  void dispose() {
    _logger.d('SearchConditionRepositoryImpl dispose');
  }
}
