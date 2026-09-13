import 'package:domain/domain.dart';

import '../dao/realm_volume_dao.dart';

class RealmVolumesMapper {
  static ManholeCardVolumes convertToEntity({
    required List<RealmVolumeDAO> daoList,
  }) {
    return ManholeCardVolumes(
      list: daoList.map(
        (element) {
          return ManholeCardVolume(
            id: element.id,
            name: element.name,
          );
        },
      ).toList(),
    );
  }

  static List<RealmVolumeDAO> convertFromEntity({
    required ManholeCardVolumes entity,
  }) {
    return entity.map(
      (element) {
        return RealmVolumeDAO(
          element.id,
          element.name,
        );
      },
    ).toList();
  }
}
