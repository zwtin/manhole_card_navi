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
  Future<Result<List<AlreadyGetCardDTO>>> get() async {
    try {
      return Result.success(
        _toDTOList(_instance.getStringList(_key, defaultValue: []).getValue()),
      );
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  @override
  Stream<List<AlreadyGetCardDTO>> getStream() {
    return _instance.getStringList(_key, defaultValue: []).map(_toDTOList);
  }

  static List<AlreadyGetCardDTO> _toDTOList(List<String> cardIds) {
    return cardIds.map((cardId) => AlreadyGetCardDTO(cardId: cardId)).toList();
  }

  void dispose() {
    _logger.d('AlreadyGetCardQueryServiceImpl dispose');
  }
}
