import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:data/src/repository/failure_recorder.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class AlreadyGetCardRepositoryImpl implements AlreadyGetCardRepository {
  AlreadyGetCardRepositoryImpl(
    this._preferences,
    this._failureRecorder,
  );

  static const _key = 'already_get_cards';

  final StreamingSharedPreferences _preferences;
  final FailureRecorder _failureRecorder;

  Preference<List<String>> get _cardIds =>
      _preferences.getStringList(_key, defaultValue: []);

  @override
  Stream<Set<String>> watch() {
    return _cardIds.map((cardIds) => cardIds.toSet());
  }

  @override
  Future<Result<void>> save({
    required String cardId,
  }) {
    return _failureRecorder.guard(
      () => _write({..._cardIds.getValue(), cardId}),
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  @override
  Future<Result<void>> delete({
    required String cardId,
  }) {
    return _failureRecorder.guard(
      () => _write(_cardIds.getValue().toSet()..remove(cardId)),
      convert: DomainExceptionMapper.fromLocalStorage,
    );
  }

  Future<void> _write(Set<String> cardIds) async {
    if (!await _preferences.setStringList(_key, cardIds.toList())) {
      throw const PersistenceException(detail: '取得済みカードを保存できませんでした');
    }
  }
}
