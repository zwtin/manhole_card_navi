import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_contact_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';
import '/use_case/dto/list_card_dto.dart';
import '/use_case/query_service/list_cards_query_service.dart';

final listCardsQueryServiceProvider =
    Provider.autoDispose<ListCardsQueryService>(
  (ref) {
    final listCardsQueryService = ListCardsQueryServiceImpl();
    ref.onDispose(listCardsQueryService.dispose);
    return listCardsQueryService;
  },
);

class ListCardsQueryServiceImpl implements ListCardsQueryService {
  final _logger = Logger();

  @override
  Future<Result<List<ListCardDTO>>> fetch() async {
    try {
      final config = Configuration.local([
        RealmCardDAO.schema,
        RealmContactDAO.schema,
        RealmImageDAO.schema,
        RealmPrefectureDAO.schema,
        RealmVolumeDAO.schema,
      ]);
      var realm = Realm(config);

      final cardDAOList = realm.all<RealmCardDAO>();
      if (cardDAOList.isEmpty) {
        throw const CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした。',
        );
      }

      final cardDTOList = cardDAOList.map((dao) {
        return ListCardDTO(
          id: dao.id,
          name: dao.name,
          colorImageUrl: dao.image?.colorResized ?? '',
          grayImageUrl: dao.image?.grayResized ?? '',
          prefectureId: dao.prefecture?.id ?? '',
          prefectureName: dao.prefecture?.name ?? '',
          volumeId: dao.volume?.id ?? '',
          volumeName: dao.volume?.name ?? '',
          publicationDate: dao.publicationDate,
        );
      }).toList();

      return Result.success(cardDTOList);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'リストデータの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('ListCardsQueryServiceImpl dispose');
  }
}
