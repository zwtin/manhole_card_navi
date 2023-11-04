import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realm/realm.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/use_case/dto/map_card_dto.dart';
import '/use_case/query_service/position_cards_query_service.dart';

final positionCardsQueryServiceProvider =
    Provider.autoDispose<PositionCardsQueryService>(
  (ref) {
    final positionCardsQueryService = PositionCardsQueryServiceImpl();
    ref.onDispose(positionCardsQueryService.dispose);
    return positionCardsQueryService;
  },
);

class PositionCardsQueryServiceImpl implements PositionCardsQueryService {
  final _logger = Logger();

  @override
  Future<Result<List<MapCardDTO>>> fetch() async {
    final config = Configuration.local([
      RealmCardDAO.schema,
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

    final appDirectory = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory('${appDirectory.path}/images');

    final dtoList = daoList.map((dao) {
      final DistributionStateDTO distributionState;
      switch (dao.distributionState) {
        case 'distributing':
          distributionState = DistributionStateDTO.distributing;
          break;
        case 'stopped;':
          distributionState = DistributionStateDTO.stopped;
          break;
        case 'notClear;':
          distributionState = DistributionStateDTO.notClear;
          break;
        default:
          distributionState = DistributionStateDTO.notClear;
          break;
      }
      final imageDAO = realm
          .all<RealmImageDAO>()
          .query(
            "id == '${dao.image?.id ?? ''}'",
          )
          .first;
      final imagePath = '${imageDirectory.path}/${imageDAO.name}';

      return MapCardDTO(
        id: dao.id,
        imagePath: imagePath,
        distributionState: distributionState,
        latitude: dao.latitude,
        longitude: dao.longitude,
      );
    }).toList();
    return Result.success(dtoList);
  }

  void dispose() {
    _logger.d('PositionCardsQueryServiceImpl dispose');
  }
}
