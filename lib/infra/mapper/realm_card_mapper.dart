import '/domain/entity/manhole_card.dart';
import '/domain/entity/manhole_card_distribution_state.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';
import '/infra/mapper/realm_distribution_points_mapper.dart';
import '/infra/mapper/realm_prefecture_mapper.dart';
import '/infra/mapper/realm_volume_mapper.dart';

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
      distributionState: ManholeCardDistributionState.fromString(
        dao.distributionState,
      ),
      image: dao.image,
      distributionPlaceHtml: dao.distributionPlaceHtml,
      stockHtml: dao.stockHtml,
      distributionPoints: RealmDistributionPointsMapper.convertToEntity(
        daoList: dao.distributionPoints.toList(),
      ),
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
}
