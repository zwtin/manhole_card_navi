import '/domain/entity/manhole_card_distribution_state.dart';
import '/domain/entity/manhole_cards.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/mapper/realm_distribution_points_mapper.dart';
import '/infra/mapper/realm_prefecture_mapper.dart';
import '/infra/mapper/realm_volume_mapper.dart';

class RealmCardsMapper {
  static List<RealmCardDAO> convertFromEntity({
    required ManholeCards entity,
  }) {
    return entity.map(
      (element) {
        final dao = RealmCardDAO(
          element.id,
          element.latitude,
          element.longitude,
          element.name,
          element.publicationDate,
          element.distributionState.toStringValue(),
          element.image,
          element.distributionPlaceHtml,
          element.distributionTimeHtml,
          element.stockHtml,
        );
        dao.prefecture = RealmPrefectureMapper.convertFromEntity(
          entity: element.prefecture,
        );
        dao.volume = RealmVolumeMapper.convertFromEntity(
          entity: element.volume,
        );
        dao.distributionPoints.addAll(
          RealmDistributionPointsMapper.convertFromEntity(
            entity: element.distributionPoints,
          ),
        );
        return dao;
      },
    ).toList();
  }
}
