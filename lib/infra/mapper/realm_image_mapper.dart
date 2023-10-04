import '/domain/entity/manhole_card_image.dart';
import '/infra/dao/realm_image_dao.dart';

class RealmImageMapper {
  static ManholeCardImage convertToModel({
    required RealmImageDAO dao,
  }) {
    return ManholeCardImage(
      id: dao.id,
      name: dao.name,
    );
  }
}
