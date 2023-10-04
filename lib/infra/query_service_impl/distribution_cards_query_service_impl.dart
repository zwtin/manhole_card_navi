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
import '/infra/dao/realm_distribution_dao.dart';
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
      RealmDistributionDAO.schema,
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

    final dtoList = daoList.map((dao) {
      final String pinImagePath;
      final distributionDAO = realm
          .all<RealmDistributionDAO>()
          .query(
            "id == '${dao.distributions.first.id}'",
          )
          .first;
      switch (distributionDAO.state) {
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
            "id == '${dao.images.first.id}'",
          )
          .first;
      final imagePath = '${imageDirectory.path}/${imageDAO.name}';

      return MapCardDTO(
        id: dao.id,
        title: dao.name,
        pinImagePath: pinImagePath,
        cardImagePath: imagePath,
        latitude: dao.latitude,
        longitude: dao.longitude,
      );
    }).toList();
    return Result.success(dtoList);
  }

  void dispose() {
    _logger.d('DistributionCardsQueryServiceImpl dispose');
  }
}
