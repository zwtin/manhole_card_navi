import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/preferences_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:data/src/mapper/search_condition_mapper.dart';
import 'package:data/src/model/search_condition_model.dart';
import 'package:domain/domain.dart';

class SearchConditionRepositoryImpl implements SearchConditionRepository {
  SearchConditionRepositoryImpl(
    this._preferences,
    this._crashlytics,
  );

  static const _key = 'search_condition';

  final PreferencesDataSource _preferences;
  final CrashlyticsDataSource _crashlytics;

  @override
  Stream<SearchCondition> watch() {
    return _preferences.watchString(_key).map(_toSearchCondition);
  }

  @override
  Future<Result<void>> save({
    required SearchCondition searchCondition,
  }) async {
    try {
      final saved = await _preferences.writeString(
        _key,
        SearchConditionMapper.toModel(searchCondition).toJsonString(),
      );
      if (!saved) {
        throw const PersistenceException(detail: '検索条件を保存できませんでした');
      }
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  static SearchCondition _toSearchCondition(String source) {
    return SearchConditionMapper.toSearchCondition(
      SearchConditionModel.fromJsonString(source),
    );
  }
}
