import '/domain/entity/manhole_cards.dart';
import '/infra/dao/realm_card_dao.dart';
import '/infra/mapper/realm_contact_mapper.dart';
import '/infra/mapper/realm_distribution_mapper.dart';
import '/infra/mapper/realm_image_mapper.dart';
import '/infra/mapper/realm_prefecture_mapper.dart';
import '/infra/mapper/realm_volume_mapper.dart';

class RealmCardMapper {
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
          RealmContactMapper.convertFromModel(
            model: element.contacts,
          ),
        );
        dao.distributions.addAll(
          RealmDistributionMapper.convertFromModel(
            model: element.distributions,
          ),
        );
        dao.images.addAll(
          RealmImageMapper.convertFromModel(
            model: element.images,
          ),
        );
        dao.prefectures.addAll(
          RealmPrefectureMapper.convertFromModel(
            model: element.prefectures,
          ),
        );
        dao.volumes.addAll(
          RealmVolumeMapper.convertFromModel(
            model: element.volumes,
          ),
        );
        return dao;
      },
    ).toList();
  }
}
