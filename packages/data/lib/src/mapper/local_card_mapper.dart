import 'package:domain/domain.dart';

import '../model/local_card_model.dart';

/// 端末に保存するカード（model）とエンティティの変換。
abstract final class LocalCardMapper {
  static LocalCardModel toModel(ManholeCard card) {
    return LocalCardModel(
      id: card.id,
      position: _toCoordinateModel(card.position),
      name: card.name,
      publicationDate: card.publicationDate,
      distributionState: card.distributionState,
      image: card.image,
      imageSub: card.imageSub,
      distributionPlaceHtml: card.distributionPlaceHtml,
      distributionTimeHtml: card.distributionTimeHtml,
      stockHtml: card.stockHtml,
      distributionPoints: [
        for (final point in card.distributionPoints) _toCoordinateModel(point),
      ],
      prefecture: LocalNamedModel(
        id: card.prefecture.id,
        name: card.prefecture.name,
      ),
      volume: LocalNamedModel(id: card.volume.id, name: card.volume.name),
    );
  }

  static ManholeCard toCard(LocalCardModel model) {
    return ManholeCard(
      id: model.id,
      position: _toCoordinate(model.position),
      name: model.name,
      publicationDate: model.publicationDate,
      distributionState: model.distributionState,
      image: model.image,
      imageSub: model.imageSub,
      distributionPlaceHtml: model.distributionPlaceHtml,
      distributionTimeHtml: model.distributionTimeHtml,
      stockHtml: model.stockHtml,
      distributionPoints: [
        for (final point in model.distributionPoints) _toCoordinate(point),
      ],
      prefecture: ManholeCardPrefecture(
        id: model.prefecture.id,
        name: model.prefecture.name,
      ),
      volume: ManholeCardVolume(id: model.volume.id, name: model.volume.name),
    );
  }

  static LocalCoordinateModel _toCoordinateModel(Coordinate coordinate) {
    return LocalCoordinateModel(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude,
    );
  }

  static Coordinate _toCoordinate(LocalCoordinateModel model) {
    return Coordinate(latitude: model.latitude, longitude: model.longitude);
  }
}
