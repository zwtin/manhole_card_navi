import 'package:domain/domain.dart';

import '../model/firestore_master_models.dart';
import 'distribution_state_mapper.dart';

/// Firestore の `master/{バージョン}` 配下のドキュメント（model）をエンティティにする。
abstract final class FirestoreMasterMapper {
  static Prefecture toPrefecture(FirestorePrefectureModel model) {
    return Prefecture(id: model.id, name: model.name);
  }

  static Volume toVolume(FirestoreVolumeModel model) {
    return Volume(id: model.id, name: model.name);
  }

  /// カードにし、都道府県・弾の名前を [prefectures] / [volumes]（ID から引く表）
  /// から引き当てる。
  static ManholeCard toCard(
    FirestoreCardModel model, {
    required Map<String, Prefecture> prefectures,
    required Map<String, Volume> volumes,
  }) {
    return ManholeCard(
      id: model.id,
      position: Coordinate(
        latitude: model.location.latitude,
        longitude: model.location.longitude,
      ),
      name: model.name,
      publicationDate: model.publicationDate,
      distributionState: DistributionStateMapper.toDistributionState(
        model.distributionState,
      ),
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
      // カードと同じ扱いにする（Prefecture.isNationwide）。
      prefecture: prefectures[model.prefectureId] ??
          Prefecture(id: model.prefectureId, name: ''),
      volume: volumes[model.volumeId] ??
          Volume(id: model.volumeId, name: ''),
    );
  }
}
