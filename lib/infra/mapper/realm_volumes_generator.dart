import '/domain/entity/manhole_card_volumes.dart';
import '/infra/dao/realm_volume_dao.dart';

class RealmVolumesGenerator {
  static List<RealmVolumeDAO> generate({required ManholeCardVolumes model}) {
    return model.map(
      (element) {
        return RealmVolumeDAO(
          element.id,
          element.name,
        );
      },
    ).toList();
  }
}
