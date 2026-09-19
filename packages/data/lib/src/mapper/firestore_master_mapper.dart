import '../model/firestore_master_models.dart';
import '../model/local_card_model.dart';

/// Firestore の `master/{バージョン}` 配下のドキュメント（model）を、端末に保存する
/// カード（model）にする。
abstract final class FirestoreMasterMapper {
  /// 都道府県・弾の名前を [prefectures] / [volumes]（ID から名前を引く表）から
  /// 引き当てる。
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
      // image_sub_url（代替配信元）を持たない世代の master もあるため、無ければ空文字。
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
      // prefectures に無い都道府県 ID のカードは名前を空にし、国の機関・全国組織の
      // カードと同じ扱いにする（Prefecture.isNationwide）。
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
