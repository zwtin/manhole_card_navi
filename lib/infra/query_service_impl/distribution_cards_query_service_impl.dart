import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/gen/assets.gen.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_contact_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';
import '/use_case/dto/map_card_dto.dart';
import '/use_case/query_service/distribution_cards_query_service.dart';

final distributionCardsQueryServiceProvider =
    Provider.autoDispose<DistributionCardsQueryService>(
  (ref) {
    final distributionCardsQueryService = DistributionCardsQueryServiceImpl();
    ref.onDispose(distributionCardsQueryService.dispose);
    return distributionCardsQueryService;
  },
);

class DistributionCardsQueryServiceImpl
    implements DistributionCardsQueryService {
  final _logger = Logger();

  @override
  Future<Result<List<MapCardDTO>>> fetch() async {
    final config = Configuration.local([
      RealmCardDAO.schema,
      RealmContactDAO.schema,
      RealmImageDAO.schema,
      RealmPrefectureDAO.schema,
      RealmVolumeDAO.schema,
    ]);
    var realm = Realm(config);

    final daoList = realm.all<RealmCardDAO>();
    if (daoList.isEmpty) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした',
        ),
      );
    }

    final appDirectory = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory('${appDirectory.path}/images');

    final dtoList = <MapCardDTO>[];
    for (final dao in daoList) {
      final String pinImagePath;
      switch (dao.distributionState) {
        case 'distributing':
          pinImagePath = Assets.images.frameGreen.path;
          break;
        case 'stopped;':
          pinImagePath = Assets.images.frameRed.path;
          break;
        case 'notClear;':
          pinImagePath = Assets.images.frameYellow.path;
          break;
        default:
          pinImagePath = Assets.images.frameGray.path;
          break;
      }
      final imageDAO = realm
          .all<RealmImageDAO>()
          .query(
            "id == '${dao.image?.id ?? ''}'",
          )
          .first;
      final imagePath = '${imageDirectory.path}/${imageDAO.name}';

      for (final contact in dao.contacts) {
        final contactDAO = realm
            .all<RealmContactDAO>()
            .query(
              "id == '${contact.id}'",
            )
            .first;

        dtoList.add(
          MapCardDTO(
            id: dao.id,
            pinImagePath: pinImagePath,
            cardImagePath: imagePath,
            latitude: contactDAO.latitude,
            longitude: contactDAO.longitude,
          ),
        );
      }
    }

    return Result.success(dtoList);
  }

  void dispose() {
    _logger.d('DistributionCardsQueryServiceImpl dispose');
  }
}
