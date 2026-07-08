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
import '/use_case/dto/map_marker_dto.dart';
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
  Future<Result<List<MapMarkerDTO>>> fetch() async {
    try {
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
        throw const CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした。',
        );
      }

      final dtoList = <MapMarkerDTO>[];
      for (final dao in daoList) {
        final colorImageUrl = dao.image?.colorOriginal ?? '';

        dtoList.add(
          MapMarkerDTO(
            cardId: dao.id,
            colorImageUrl: colorImageUrl,
            grayImageUrl: colorImageUrl,
            distributionState: dao.distributionState,
            latitude: dao.latitude,
            longitude: dao.longitude,
          ),
        );
      }

      return Result.success(dtoList);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '蓋データの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('PositionCardsQueryServiceImpl dispose');
  }
}
