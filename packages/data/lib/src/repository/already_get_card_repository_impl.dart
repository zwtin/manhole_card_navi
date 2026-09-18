import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';

class AlreadyGetCardRepositoryImpl implements AlreadyGetCardRepository {
  AlreadyGetCardRepositoryImpl(
    this._instance,
  );

  /// 取得済みカードの ID の一覧を保存する SharedPreferences のキー。
  static const _key = 'already_get_cards';

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<void>> save({
    required ManholeCard manholeCard,
  }) async {
    try {
      final list = _instance.getStringList(_key, defaultValue: []).getValue();
      if (!list.contains(manholeCard.id)) {
        list.add(manholeCard.id);
      }
      await _write(list);
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<void>> delete({
    required ManholeCard manholeCard,
  }) async {
    try {
      final list = _instance.getStringList(_key, defaultValue: []).getValue();
      list.remove(manholeCard.id);
      await _write(list);
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  Future<void> _write(List<String> cardIds) async {
    if (!await _instance.setStringList(_key, cardIds)) {
      throw const PersistenceException(detail: '取得済みカードを保存できませんでした');
    }
  }

  void dispose() {
    _logger.d('AlreadyGetCardRepositoryImpl dispose');
  }
}
