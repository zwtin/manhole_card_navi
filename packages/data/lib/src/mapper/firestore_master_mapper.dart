import 'package:data/src/model/firestore_master_models.dart';
import 'package:data/src/model/local_card_model.dart';

abstract final class FirestoreMasterMapper {
  /// 都道府県と弾は別のドキュメントにあるので、名前は引き当ててから渡す。
  static LocalCardModel toLocalCard(
    FirestoreCardModel model, {
    required String prefectureName,
    required String volumeName,
  }) {
    return LocalCardModel(
      id: model.id,
      position: LocalCoordinateModel(
        latitude: model.location.latitude,
        longitude: model.location.longitude,
      ),
      name: model.name,
      publicationDate: model.publicationDate,
      distributionState: model.distributionState,
      image: model.imageUrl,
      imageSub: model.imageSubUrl,
      distributionPlaceHtml: model.distributionPlaceHtml,
      distributionTimeHtml: model.distributionTimeHtml,
      stockHtml: model.stockHtml,
      distributionPoints: [
        for (final point in model.distributionPoints)
          LocalCoordinateModel(
            latitude: point.latitude,
            longitude: point.longitude,
          ),
      ],
      prefecture: LocalNamedModel(id: model.prefectureId, name: prefectureName),
      volume: LocalNamedModel(id: model.volumeId, name: volumeName),
    );
  }

  static LocalCardUpdateModel toLocalCardUpdate(
    FirestoreCardUpdateModel model,
  ) {
    return LocalCardUpdateModel(
      id: model.id,
      distributionState: model.distributionState,
      distributionPlaceHtml: model.distributionPlaceHtml,
      distributionTimeHtml: model.distributionTimeHtml,
      stockHtml: model.stockHtml,
      distributionPoints: [
        for (final point in model.distributionPoints)
          LocalCoordinateModel(
            latitude: point.latitude,
            longitude: point.longitude,
          ),
      ],
    );
  }
}
