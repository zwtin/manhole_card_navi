import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/infra/dao/realm_contact_dao.dart';
import 'package:manhole_card_navi/infra/dao/realm_prefecture_dao.dart';
import 'package:manhole_card_navi/infra/dao/realm_volume_dao.dart';
import 'package:manhole_card_navi/use_case/dto/list_card_dto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/use_case/dto/list_prefecture_dto.dart';
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
  Future<Result<List<ListPrefectureDTO>>> fetch() async {
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
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした',
        ),
      );
    }

    final appDirectory = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory('${appDirectory.path}/images');

    final cardDTOList = cardDAOList.map((dao) {
      final imageDAO = realm
          .all<RealmImageDAO>()
          .query(
            "id == '${dao.image?.id ?? ''}'",
          )
          .first;
      final imagePath = '${imageDirectory.path}/${imageDAO.name}';

      return ListCardDTO(
        id: dao.id,
        name: dao.name,
        imagePath: imagePath,
        prefectureId: dao.prefecture?.id ?? '',
      );
    }).toList();

    final prefectureDAOList = realm.all<RealmPrefectureDAO>();
    if (prefectureDAOList.isEmpty) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした',
        ),
      );
    }

    final prefectureDTOList = prefectureDAOList.map(
      (dao) {
        return ListPrefectureDTO(
          id: dao.id,
          name: dao.name,
          cards: cardDTOList.where(
            (element) {
              return element.prefectureId == dao.id;
            },
          ).toList(),
        );
      },
    ).toList();

    return Result.success(prefectureDTOList);
  }

  void dispose() {
    _logger.d('ListCardsQueryServiceImpl dispose');
  }
}
