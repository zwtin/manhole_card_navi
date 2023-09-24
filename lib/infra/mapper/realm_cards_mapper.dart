import '/domain/entity/manhole_cards.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/mapper/realm_contacts_mapper.dart';
import '/infra/mapper/realm_distributions_mapper.dart';
import '/infra/mapper/realm_images_mapper.dart';
import '/infra/mapper/realm_prefectures_mapper.dart';
import '/infra/mapper/realm_volumes_mapper.dart';

class RealmCardsMapper {
  static List<RealmCardDAO> convertFromModel({
    required ManholeCards model,
  }) {
    return model.map(
      (element) {
        final dao = RealmCardDAO(
          element.id,
          element.latitude,
          element.longitude,
          element.name,
          element.publicationDate,
        );
        dao.contacts.addAll(
          RealmContactsMapper.convertFromModel(
            model: element.contacts,
          ),
        );
        dao.distributions.addAll(
          RealmDistributionsMapper.convertFromModel(
            model: element.distributions,
          ),
        );
        dao.images.addAll(
          RealmImagesMapper.convertFromModel(
            model: element.images,
          ),
        );
        dao.prefectures.addAll(
          RealmPrefecturesMapper.convertFromModel(
            model: element.prefectures,
          ),
        );
        dao.volumes.addAll(
          RealmVolumesMapper.convertFromModel(
            model: element.volumes,
          ),
        );
        return dao;
      },
    ).toList();
  }
}
