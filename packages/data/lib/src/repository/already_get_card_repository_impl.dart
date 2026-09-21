import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class AlreadyGetCardRepositoryImpl implements AlreadyGetCardRepository {
  AlreadyGetCardRepositoryImpl(
    this._preferences,
    this._crashlytics,
  );

  static const _key = 'already_get_cards';

  final StreamingSharedPreferences _preferences;
  final CrashlyticsDataSource _crashlytics;

  Preference<List<String>> get _cardIds =>
      _preferences.getStringList(_key, defaultValue: []);

  @override
  Stream<Set<String>> watch() {
    return _cardIds.map((cardIds) => cardIds.toSet());
  }

  @override
  Future<Result<void>> save({
    required String cardId,
  }) async {
    try {
      await _write({..._cardIds.getValue(), cardId});
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
      await _write(_cardIds.getValue().toSet()..remove(cardId));
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }

  Future<void> _write(Set<String> cardIds) async {
    if (!await _preferences.setStringList(_key, cardIds.toList())) {
      throw const PersistenceException(detail: '取得済みカードを保存できませんでした');
    }
  }
}
