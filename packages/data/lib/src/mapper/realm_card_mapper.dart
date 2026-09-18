import 'package:domain/domain.dart';

import '../dao/realm_card_dao.dart';
import '../dao/realm_prefecture_dao.dart';
import '../dao/realm_volume_dao.dart';
import 'realm_distribution_point_mapper.dart';
import 'realm_prefecture_mapper.dart';
import 'realm_volume_mapper.dart';

class RealmCardMapper {
  static ManholeCard convertToEntity({
    required RealmCardDAO dao,
  }) {
    return ManholeCard(
      id: dao.id,
      latitude: dao.latitude,
      longitude: dao.longitude,
      name: dao.name,
      publicationDate: dao.publicationDate,
      distributionState: ManholeCardDistributionState.values.byName(
        dao.distributionState,
      ),
      image: dao.image,
      imageSub: dao.imageSub,
      distributionPlaceHtml: dao.distributionPlaceHtml,
      distributionTimeHtml: dao.distributionTimeHtml,
      stockHtml: dao.stockHtml,
      distributionPoints: dao.distributionPoints
          .map(
            (point) => RealmDistributionPointMapper.convertToEntity(dao: point),
          )
          .toList(),
      prefecture: RealmPrefectureMapper.convertToEntity(
        dao: dao.prefecture ??
            RealmPrefectureDAO(
              '',
              '',
            ),
      ),
      volume: RealmVolumeMapper.convertToEntity(
        dao: dao.volume ??
            RealmVolumeDAO(
              '',
              '',
            ),
      ),
    );
  }

  static RealmCardDAO convertFromEntity({
    required ManholeCard entity,
  }) {
    final dao = RealmCardDAO(
      entity.id,
      entity.latitude,
      entity.longitude,
      entity.name,
      entity.publicationDate,
      entity.distributionState.name,
      entity.image,
      entity.imageSub,
      entity.distributionPlaceHtml,
      entity.distributionTimeHtml,
      entity.stockHtml,
    );
    dao.prefecture = RealmPrefectureMapper.convertFromEntity(
      entity: entity.prefecture,
    );
    dao.volume = RealmVolumeMapper.convertFromEntity(
      entity: entity.volume,
    );
    dao.distributionPoints.addAll(
      entity.distributionPoints.map(
        (point) => RealmDistributionPointMapper.convertFromEntity(
          entity: point,
        ),
      ),
    );
    return dao;
  }
}
