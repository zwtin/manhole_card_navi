import '/domain/entity/manhole_card_images.dart';
import '/infra/dao/realm_image_dao.dart';

class RealmImageMapper {
  static List<RealmImageDAO> convertFromModel({
    required ManholeCardImages model,
  }) {
    return model.map(
      (element) {
        return RealmImageDAO(
          element.id,
          element.name,
          element.path,
        );
      },
    ).toList();
  }
}
