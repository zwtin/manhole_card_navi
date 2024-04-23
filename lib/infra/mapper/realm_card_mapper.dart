import '/domain/entity/manhole_card.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';
import '/infra/mapper/realm_contacts_mapper.dart';
import '/infra/mapper/realm_image_mapper.dart';
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
      distributionState: ManholeCardDistributionState.values.byName(
        dao.distributionState,
      ),
      distributionLinkText: dao.distributionLinkText,
      distributionLinkUrl: dao.distributionLinkUrl,
      distributionText: dao.distributionText,
      distributionOther: dao.distributionOther,
      contacts: RealmContactsMapper.convertToEntity(
        daoList: dao.contacts,
      ),
      image: RealmImageMapper.convertToEntity(
        dao: dao.image ?? RealmImageDAO('', ''),
      ),
      prefecture: RealmPrefectureMapper.convertToEntity(
        dao: dao.prefecture ?? RealmPrefectureDAO('', ''),
      ),
      volume: RealmVolumeMapper.convertToEntity(
        dao: dao.volume ?? RealmVolumeDAO('', ''),
      ),
    );
  }
}
