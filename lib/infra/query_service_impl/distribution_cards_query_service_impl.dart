import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_distribution_dao.dart';
import '/infra/dao/realm_image_dao.dart';
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
      RealmDistributionDAO.schema,
      RealmImageDAO.schema,
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

    final dtoList = daoList.map((dao) {
      final MapCardState dtoState;
      final distributionDAO = realm
          .all<RealmDistributionDAO>()
          .query(
            "id == '${dao.distributions.first.id}'",
          )
          .first;
      switch (distributionDAO.state) {
        case 'distributing':
          dtoState = MapCardState.distributing;
          break;
        case 'stopped;':
          dtoState = MapCardState.stopped;
          break;
        case 'notClear;':
          dtoState = MapCardState.notClear;
          break;
        default:
          dtoState = MapCardState.notClear;
          break;
      }
      final imageDAO = realm
          .all<RealmImageDAO>()
          .query(
            "id == '${dao.images.first.id}'",
          )
          .first;
      return MapCardDTO(
        id: dao.id,
        title: dao.name,
        cardImagePath: imageDAO.path,
        latitude: dao.latitude,
        longitude: dao.longitude,
        state: dtoState,
      );
    }).toList();
    return Result.success(dtoList);
  }

  void dispose() {
    _logger.d('DistributionCardsQueryServiceImpl dispose');
  }
}
