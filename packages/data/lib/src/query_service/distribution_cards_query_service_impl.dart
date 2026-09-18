import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_configuration.dart';
import '../exception/domain_exception_converter.dart';

class DistributionCardsQueryServiceImpl
    implements DistributionCardsQueryService {
  final _logger = Logger();

  @override
  Future<Result<List<MapMarkerDTO>>> fetch() async {
    try {
      final realm = RealmConfiguration.open();
      try {
        final daoList = realm.all<RealmCardDAO>();
        if (daoList.isEmpty) {
          throw const NotFoundException(detail: '端末にマスターデータがありません');
        }

        // 配布場所は 1 カードに 0〜複数ある。地点ごとに 1 マーカーを立てる。
        final dtoList = <MapMarkerDTO>[];
        for (final dao in daoList) {
          for (final point in dao.distributionPoints) {
            dtoList.add(
              MapMarkerDTO(
                cardId: dao.id,
                imagePath: dao.image,
                imageSubPath: dao.imageSub,
                distributionState: dao.distributionState,
                volumeId: dao.volume?.id ?? '',
                latitude: point.latitude,
                longitude: point.longitude,
              ),
            );
          }
        }
        return Result.success(dtoList);
      } finally {
        realm.close();
      }
    } on Exception catch (error, stackTrace) {
      return Result.failure(
        DomainExceptionConverter.fromLocalStorage(error, stackTrace),
      );
    }
  }

  void dispose() {
    _logger.d('DistributionCardsQueryServiceImpl dispose');
  }
}
