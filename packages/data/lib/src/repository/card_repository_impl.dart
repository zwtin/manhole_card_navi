import 'package:domain/domain.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_configuration.dart';
import '../mapper/realm_card_mapper.dart';

class CardRepositoryImpl implements CardRepository {
  final _logger = Logger();

  @override
  Future<Result<ManholeCard>> get({
    required String id,
  }) async {
    try {
      var realm = RealmConfiguration.open();

      final daoOrNull = realm
          .all<RealmCardDAO>()
          .query(
            "id == '$id'",
          )
          .firstOrNull;
      if (daoOrNull == null) {
        throw const CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした。',
        );
      }
      final card = RealmCardMapper.convertToEntity(dao: daoOrNull);
      realm.close();
      return Result.success(card);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'カードデータの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('CardRepositoryImpl dispose');
  }
}
