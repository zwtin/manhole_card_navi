import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_configuration.dart';
import '/use_case/dto/map_marker_dto.dart';
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

      // 配布場所は 1 カードに 0〜複数ある。地点ごとに 1 マーカーを立てる。
      final dtoList = <MapMarkerDTO>[];
      for (final dao in daoList) {
        for (final point in dao.distributionPoints) {
          dtoList.add(
            MapMarkerDTO(
              cardId: dao.id,
              imagePath: dao.image,
              distributionState: dao.distributionState,
              latitude: point.latitude,
              longitude: point.longitude,
            ),
          );
        }
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
          text: '配布場所データの取得に失敗しました。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('DistributionCardsQueryServiceImpl dispose');
  }
}
