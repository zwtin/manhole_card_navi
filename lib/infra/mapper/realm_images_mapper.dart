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
            colorOriginal: element.colorOriginal,
            colorResized: element.colorResized,
            colorFrameGreen: element.colorFrameGreen,
            colorFrameRed: element.colorFrameRed,
            colorFrameYellow: element.colorFrameYellow,
            grayOriginal: element.grayOriginal,
            grayResized: element.grayResized,
            grayFrameGreen: element.grayFrameRed,
            grayFrameRed: element.grayFrameRed,
            grayFrameYellow: element.grayFrameYellow,
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
          element.colorOriginal,
          element.colorResized,
          element.colorFrameGreen,
          element.colorFrameRed,
          element.colorFrameYellow,
          element.grayOriginal,
          element.grayResized,
          element.grayFrameGreen,
          element.grayFrameRed,
          element.grayFrameYellow,
        );
      },
    ).toList();
  }
}
