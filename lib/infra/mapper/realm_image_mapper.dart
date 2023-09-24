import 'package:manhole_card_navi/domain/entity/manhole_card_image.dart';
import 'package:manhole_card_navi/infra/dao/realm_image_dao.dart';

class RealmImageMapper {
  static ManholeCardImage convertToModel({
    required RealmImageDAO dao,
  }) {
    return ManholeCardImage(
      id: dao.id,
      name: dao.name,
      path: dao.path,
    );
  }
}
