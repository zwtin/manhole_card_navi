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
        final String colorImageUrl;
        final String grayImageUrl;
        switch (dao.distributionState) {
          case 'distributing':
            colorImageUrl = dao.image?.colorFrameGreen ?? '';
            grayImageUrl = dao.image?.grayFrameGreen ?? '';
            break;
          case 'stopped':
            colorImageUrl = dao.image?.colorFrameRed ?? '';
            grayImageUrl = dao.image?.grayFrameRed ?? '';
            break;
          case 'notClear':
            colorImageUrl = dao.image?.colorFrameYellow ?? '';
            grayImageUrl = dao.image?.grayFrameYellow ?? '';
            break;
          default:
            colorImageUrl = dao.image?.colorFrameYellow ?? '';
            grayImageUrl = dao.image?.grayFrameYellow ?? '';
            break;
        }

        for (final contact in dao.contacts) {
          dtoList.add(
            MapMarkerDTO(
              cardId: dao.id,
              colorImageUrl: colorImageUrl,
              grayImageUrl: grayImageUrl,
              latitude: contact.latitude,
              longitude: contact.longitude,
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
