import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/preferences_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class AlreadyGetCardRepositoryImpl implements AlreadyGetCardRepository {
  AlreadyGetCardRepositoryImpl(
    this._preferences,
    this._crashlytics,
  );

  static const _key = 'already_get_cards';

  final PreferencesDataSource _preferences;
  final CrashlyticsDataSource _crashlytics;

  @override
  Stream<Set<String>> watch() {
    return _preferences.watchStringList(_key).map((ids) => ids.toSet());
  }

  @override
  Future<Result<void>> save({
    required String cardId,
  }) async {
    try {
      await _write({..._preferences.readStringList(_key), cardId});
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  @override
  Future<Result<void>> delete({
    required String cardId,
  }) async {
    try {
      await _write(_preferences.readStringList(_key).toSet()..remove(cardId));
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  Future<void> _write(Set<String> cardIds) async {
    if (!await _preferences.writeStringList(_key, cardIds.toList())) {
      throw const PersistenceException(detail: '取得済みカードを保存できませんでした');
    }
  }
}
