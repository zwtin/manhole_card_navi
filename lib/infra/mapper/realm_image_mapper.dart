import '/domain/entity/manhole_card_image.dart';
import '/infra/dao/realm_image_dao.dart';

class RealmImageMapper {
  static ManholeCardImage convertToEntity({
    required RealmImageDAO dao,
  }) {
    return ManholeCardImage(
      id: dao.id,
      name: dao.name,
    );
  }

  static RealmImageDAO convertFromEntity({
    required ManholeCardImage entity,
  }) {
    return RealmImageDAO(
      entity.id,
      entity.name,
    );
  }
}
