import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_configuration.dart';
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
      var realm = RealmConfiguration.open();

      final daoList = realm.all<RealmCardDAO>();
      if (daoList.isEmpty) {
        throw const CustomException(
          title: 'エラー',
          text: 'データが見つかりませんでした。',
        );
      }

      final dtoList = <MapMarkerDTO>[];
      for (final dao in daoList) {
        dtoList.add(
          MapMarkerDTO(
            cardId: dao.id,
            imagePath: dao.image,
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
