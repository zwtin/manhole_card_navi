import 'package:domain/domain.dart';

import '../model/local_card_model.dart';
import 'distribution_state_mapper.dart';

/// 端末に保存するカード（model）をエンティティにする。
abstract final class LocalCardMapper {
  static ManholeCard toCard(LocalCardModel model) {
    return ManholeCard(
      id: model.id,
      position: _toCoordinate(model.position),
      name: model.name,
      publicationDate: model.publicationDate,
      distributionState: DistributionStateMapper.toDistributionState(
        model.distributionState,
      ),
      image: model.image,
      imageSub: model.imageSub,
      distributionPlaceHtml: model.distributionPlaceHtml,
      distributionTimeHtml: model.distributionTimeHtml,
      stockHtml: model.stockHtml,
      distributionPoints: [
        for (final point in model.distributionPoints) _toCoordinate(point),
      ],
      prefecture: Prefecture(
        id: model.prefecture.id,
        name: model.prefecture.name,
      ),
      volume: Volume(id: model.volume.id, name: model.volume.name),
    );
  }

  static Coordinate _toCoordinate(LocalCoordinateModel model) {
    return Coordinate(latitude: model.latitude, longitude: model.longitude);
  }
}
