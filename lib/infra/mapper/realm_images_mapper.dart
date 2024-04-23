import '/domain/entity/manhole_card_image.dart';
import '/domain/entity/manhole_card_images.dart';
import '/infra/dao/realm_image_dao.dart';

class RealmImagesMapper {
  static ManholeCardImages convertToEntity({
    required List<RealmImageDAO> daoList,
  }) {
    return ManholeCardImages(
      list: daoList.map(
        (element) {
          return ManholeCardImage(
            id: element.id,
            name: element.name,
          );
        },
      ).toList(),
    );
  }

  static List<RealmImageDAO> convertFromEntity({
    required ManholeCardImages entity,
  }) {
    return entity.map(
      (element) {
        return RealmImageDAO(
          element.id,
          element.name,
        );
      },
    ).toList();
  }
}
