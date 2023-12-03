import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
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

    final dateFormatter = DateFormat('yyyy/MM/dd');

    final cardDTOList = cardDAOList.map((dao) {
      return ListCardDTO(
        id: dao.id,
        name: dao.name,
        imagePath: dao.image == null
            ? ''
            : '${imageDirectory.path}/${dao.image!.name}',
        prefectureId: dao.prefecture?.id ?? '',
        prefectureName: dao.prefecture?.name ?? '',
        volumeId: dao.volume?.id ?? '',
        volumeName: dao.volume?.name ?? '',
        publicationDate: dateFormatter.format(dao.publicationDate),
      );
    }).toList();

    return Result.success(cardDTOList);
  }

  void dispose() {
    _logger.d('ListCardsQueryServiceImpl dispose');
  }
}
