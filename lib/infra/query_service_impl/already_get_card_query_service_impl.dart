import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/temporary_provider.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/query_service/already_get_card_query_service.dart';

final alreadyGetCardQueryServiceProvider =
    Provider.autoDispose<AlreadyGetCardQueryService>(
  (ref) {
    final alreadyGetCardQueryService = AlreadyGetCardQueryServiceImpl(
      ref.watch(sharedPreferencesProvider),
    );
    ref.onDispose(alreadyGetCardQueryService.dispose);
    return alreadyGetCardQueryService;
  },
);

class AlreadyGetCardQueryServiceImpl implements AlreadyGetCardQueryService {
  AlreadyGetCardQueryServiceImpl(
    this._instance,
  );

  final _logger = Logger();
  final StreamingSharedPreferences _instance;

  @override
  Future<Result<List<AlreadyGetCardDTO>>> get() async {
    try {
      return Result.success(
        _instance
            .getStringList(
              'already_get_cards',
              defaultValue: [],
            )
            .getValue()
            .map(
              (cardId) {
                return AlreadyGetCardDTO(cardId: cardId);
              },
            )
            .toList(),
      );
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '取得済みカードの取得に失敗しました。',
        ),
      );
    }
  }

  @override
  Stream<List<AlreadyGetCardDTO>> getStream() {
    return _instance.getStringList(
      'already_get_cards',
      defaultValue: [],
    ).map(
      (cardIdList) {
        return cardIdList.map(
          (cardId) {
            return AlreadyGetCardDTO(cardId: cardId);
          },
        ).toList();
      },
    );
  }

  void dispose() {
    _logger.d('AlreadyGetCardQueryServiceImpl dispose');
  }
}
