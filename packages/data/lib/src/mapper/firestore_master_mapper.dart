import 'package:domain/domain.dart';

import '../model/firestore_master_models.dart';

/// Firestore の `master/{バージョン}` 配下のドキュメント（model）をエンティティにする。
abstract final class FirestoreMasterMapper {
  static ManholeCardPrefecture toPrefecture(FirestorePrefectureModel model) {
    return ManholeCardPrefecture(id: model.id, name: model.name);
  }

  static ManholeCardVolume toVolume(FirestoreVolumeModel model) {
    return ManholeCardVolume(id: model.id, name: model.name);
  }

  /// カードにし、都道府県・弾の名前を [prefectures] / [volumes]（ID から引く表）
  /// から引き当てる。
  static ManholeCard toCard(
    FirestoreCardModel model, {
    required Map<String, ManholeCardPrefecture> prefectures,
    required Map<String, ManholeCardVolume> volumes,
  }) {
    return ManholeCard(
      id: model.id,
      position: Coordinate(
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
          Coordinate(latitude: point.latitude, longitude: point.longitude),
      ],
      // prefectures に無い都道府県 ID のカードは名前を空にし、国の機関・全国組織の
      // カードと同じ扱いにする（ManholeCardPrefecture.isNationwide）。
      prefecture: prefectures[model.prefectureId] ??
          ManholeCardPrefecture(id: model.prefectureId, name: ''),
      volume: volumes[model.volumeId] ??
          ManholeCardVolume(id: model.volumeId, name: ''),
    );
  }
}
