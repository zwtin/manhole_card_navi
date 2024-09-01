import '/domain/entity/manhole_card_image.dart';
import '/infra/dao/realm_image_dao.dart';

class RealmImageMapper {
  static ManholeCardImage convertToEntity({
    required RealmImageDAO dao,
  }) {
    return ManholeCardImage(
      id: dao.id,
      colorOriginal: dao.colorOriginal,
      colorResized: dao.colorResized,
      colorFrameGreen: dao.colorFrameGreen,
      colorFrameRed: dao.colorFrameRed,
      colorFrameYellow: dao.colorFrameYellow,
      grayOriginal: dao.grayOriginal,
      grayResized: dao.grayResized,
      grayFrameGreen: dao.grayFrameGreen,
      grayFrameRed: dao.grayFrameRed,
      grayFrameYellow: dao.grayFrameYellow,
    );
  }

  static RealmImageDAO convertFromEntity({
    required ManholeCardImage entity,
  }) {
    return RealmImageDAO(
      entity.id,
      entity.colorOriginal,
      entity.colorResized,
      entity.colorFrameGreen,
      entity.colorFrameRed,
      entity.colorFrameYellow,
      entity.grayOriginal,
      entity.grayResized,
      entity.grayFrameGreen,
      entity.grayFrameRed,
      entity.grayFrameYellow,
    );
  }
}
