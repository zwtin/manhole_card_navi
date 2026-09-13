import 'package:domain/domain.dart';

import '../dao/realm_card_dao.dart';
import 'realm_distribution_points_mapper.dart';
import 'realm_prefecture_mapper.dart';
import 'realm_volume_mapper.dart';

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
          element.imageSub,
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
