import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../exception/domain_exception_converter.dart';

class AlreadyGetCardQueryServiceImpl implements AlreadyGetCardQueryService {
  AlreadyGetCardQueryServiceImpl(
    this._instance,
  );

  /// 取得済みカードの ID の一覧を保存する SharedPreferences のキー。
  static const _key = 'already_get_cards';

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<Set<String>>> get() async {
    try {
      return Result.success(
        _instance.getStringList(_key, defaultValue: []).getValue().toSet(),
      );
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  @override
  Stream<Set<String>> getStream() {
    return _instance
        .getStringList(_key, defaultValue: [])
        .map((cardIds) => cardIds.toSet());
  }

  void dispose() {
    _logger.d('AlreadyGetCardQueryServiceImpl dispose');
  }
}
