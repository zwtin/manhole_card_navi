import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

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
