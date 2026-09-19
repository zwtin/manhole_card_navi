import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/mapper/search_condition_mapper.dart';
import 'package:data/src/model/search_condition_model.dart';
import 'package:domain/domain.dart';

class SearchConditionRepositoryImpl implements SearchConditionRepository {
  SearchConditionRepositoryImpl(
    this._preferences,
    this._failureRecorder,
  );

  static const _key = 'search_condition';

  final StreamingSharedPreferences _preferences;
  final FailureRecorder _failureRecorder;

  Preference<String> get _source =>
      _preferences.getString(_key, defaultValue: '');

  @override
  Stream<SearchCondition> watch() {
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
}
