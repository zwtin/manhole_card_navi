import 'package:data/src/mapper/distribution_state_mapper.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:domain/domain.dart';

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
