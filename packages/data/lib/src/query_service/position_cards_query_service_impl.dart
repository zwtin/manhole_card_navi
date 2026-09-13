import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_configuration.dart';

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
            imageSubPath: dao.imageSub,
            distributionState: dao.distributionState,
            volumeId: dao.volume?.id ?? '',
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
