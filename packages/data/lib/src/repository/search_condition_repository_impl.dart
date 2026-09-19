import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../datasource/failure_recorder.dart';
import '../mapper/domain_exception_mapper.dart';
import '../mapper/search_condition_mapper.dart';
import '../model/search_condition_model.dart';

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
      () async => _toSearchCondition(_source.getValue()),
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  @override
  Stream<SearchCondition> getStream() {
    return _source.map(_toSearchCondition);
  }

  @override
  Future<Result<void>> save({
    required SearchCondition searchCondition,
  }) {
    return _failureRecorder.guard(
      () async {
        final saved = await _preferences.setString(
          _key,
          SearchConditionMapper.toModel(searchCondition).toJsonString(),
        );
        if (!saved) {
          throw const PersistenceException(detail: '検索条件を保存できませんでした');
        }
      },
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  static SearchCondition _toSearchCondition(String source) {
    return SearchConditionMapper.toSearchCondition(
      SearchConditionModel.fromJsonString(source),
    );
  }

  void dispose() {
    _logger.d('SearchConditionRepositoryImpl dispose');
  }
}
