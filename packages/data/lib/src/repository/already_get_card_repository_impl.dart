import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../datasource/failure_recorder.dart';
import '../mapper/domain_exception_mapper.dart';

class AlreadyGetCardRepositoryImpl implements AlreadyGetCardRepository {
  AlreadyGetCardRepositoryImpl(
    this._preferences,
    this._failureRecorder,
  );

  /// 取得済みカードの ID の一覧を保存する SharedPreferences のキー。
  static const _key = 'already_get_cards';

  final _logger = Logger();
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

  void dispose() {
    _logger.d('AlreadyGetCardRepositoryImpl dispose');
  }
}
