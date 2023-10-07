import '/domain/entity/manhole_card_volume.dart';
import '/infra/dao/realm_volume_dao.dart';

class RealmVolumeMapper {
  static ManholeCardVolume convertToEntity({
    required RealmVolumeDAO dao,
  }) {
    return ManholeCardVolume(
      id: dao.id,
      name: dao.name,
    );
  }

  static RealmVolumeDAO convertFromEntity({
    required ManholeCardVolume entity,
  }) {
    return RealmVolumeDAO(
      entity.id,
      entity.name,
    );
  }
}
