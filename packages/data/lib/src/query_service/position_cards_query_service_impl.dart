import 'package:domain/domain.dart';
import 'package:logger/logger.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_configuration.dart';
import '../exception/domain_exception_converter.dart';

class PositionCardsQueryServiceImpl implements PositionCardsQueryService {
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
        return Result.success(
          daoList
              .map(
                (dao) => MapMarkerDTO(
                  cardId: dao.id,
                  imagePath: dao.image,
                  imageSubPath: dao.imageSub,
                  distributionState: dao.distributionState,
                  volumeId: dao.volume?.id ?? '',
                  latitude: dao.latitude,
                  longitude: dao.longitude,
                ),
              )
              .toList(),
        );
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
    _logger.d('PositionCardsQueryServiceImpl dispose');
  }
}
