import '/domain/entity/manhole_card.dart';
import '/domain/entity/manhole_cards.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';
import '/infra/mapper/realm_contacts_mapper.dart';
import '/infra/mapper/realm_image_mapper.dart';
import '/infra/mapper/realm_prefecture_mapper.dart';
import '/infra/mapper/realm_volume_mapper.dart';

class RealmCardsMapper {
  static ManholeCards convertToEntity({
    required List<RealmCardDAO> daoList,
  }) {
    return ManholeCards(
      list: daoList.map(
        (element) {
          return ManholeCard(
            id: element.id,
            latitude: element.latitude,
            longitude: element.longitude,
            name: element.name,
            publicationDate: element.publicationDate,
            distributionState: ManholeCardDistributionState.values.byName(
              element.distributionState,
            ),
            distributionLinkText: element.distributionLinkText,
            distributionLinkUrl: element.distributionLinkText,
            distributionText: element.distributionText,
            distributionOther: element.distributionOther,
            contacts: RealmContactsMapper.convertToEntity(
              daoList: element.contacts,
            ),
            image: RealmImageMapper.convertToEntity(
              dao: element.image ?? RealmImageDAO('', ''),
            ),
            prefecture: RealmPrefectureMapper.convertToEntity(
              dao: element.prefecture ?? RealmPrefectureDAO('', ''),
            ),
            volume: RealmVolumeMapper.convertToEntity(
              dao: element.volume ?? RealmVolumeDAO('', ''),
            ),
          );
        },
      ).toList(),
    );
  }

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
          element.distributionState.name,
          element.distributionLinkText,
          element.distributionLinkUrl,
          element.distributionText,
          element.distributionOther,
        );
        dao.image = RealmImageMapper.convertFromEntity(
          entity: element.image,
        );
        dao.prefecture = RealmPrefectureMapper.convertFromEntity(
          entity: element.prefecture,
        );
        dao.volume = RealmVolumeMapper.convertFromEntity(
          entity: element.volume,
        );
        dao.contacts.addAll(
          RealmContactsMapper.convertFromEntity(
            entity: element.contacts,
          ),
        );
        return dao;
      },
    ).toList();
  }
}
