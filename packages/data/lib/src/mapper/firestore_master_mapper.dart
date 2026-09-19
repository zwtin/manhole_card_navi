import 'package:data/src/model/firestore_master_models.dart';
import 'package:data/src/model/local_card_model.dart';

abstract final class FirestoreMasterMapper {
  /// [prefectures] と [volumes] は、ID から名前を引く表。
  static LocalCardModel toLocalCard(
    FirestoreCardModel model, {
    required Map<String, String> prefectures,
    required Map<String, String> volumes,
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
      // image_sub_url を持たない世代の master もある。
      imageSub: model.imageSubUrl ?? '',
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
      // 都道府県・弾の表にない ID は名前を空にする。カード 1 枚の食い違いで、取り込み
      // 全体を失敗させない。
      prefecture: LocalNamedModel(
        id: model.prefectureId,
        name: prefectures[model.prefectureId] ?? '',
      ),
      volume: LocalNamedModel(
        id: model.volumeId,
        name: volumes[model.volumeId] ?? '',
      ),
    );
  }
}
