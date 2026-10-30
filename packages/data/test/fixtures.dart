import 'package:data/src/model/distribution_state_model.dart';
import 'package:data/src/model/local_card_model.dart';
import 'package:domain/domain.dart';

ManholeCard card({
  String id = '27-226-B001',
  List<Coordinate> distributionPoints = const [
    Coordinate(latitude: 34.57, longitude: 135.6),
  ],
}) {
  return ManholeCard(
    id: id,
    position: const Coordinate(latitude: 34.5, longitude: 135.6),
    name: '藤井寺市',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: DistributionState.stopped,
    distributionPlaceHtml: '<p>藤井寺市役所</p>',
    distributionTimeHtml: '<p>9:00〜17:00</p>',
    stockHtml: '<p>あり</p>',
    distributionPoints: distributionPoints,
    prefecture: const Prefecture(id: '027', name: '大阪府'),
    volume: const Volume(id: '0000', name: '第1弾'),
  );
}

/// 画像の URL のほかは [card] と同じ値。
LocalCardModel localCard({
  String id = '27-226-B001',
  String? image,
  String? imageSub,
  List<LocalCoordinateModel> distributionPoints = const [
    LocalCoordinateModel(latitude: 34.57, longitude: 135.6),
  ],
}) {
  return LocalCardModel(
    id: id,
    position: const LocalCoordinateModel(latitude: 34.5, longitude: 135.6),
    name: '藤井寺市',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: DistributionStateModel.stopped,
    image: image ?? 'https://example.com/$id.jpg',
    imageSub: imageSub ?? 'https://sub.example.com/$id.jpg',
    distributionPlaceHtml: '<p>藤井寺市役所</p>',
    distributionTimeHtml: '<p>9:00〜17:00</p>',
    stockHtml: '<p>あり</p>',
    distributionPoints: distributionPoints,
    prefecture: const LocalNamedModel(id: '027', name: '大阪府'),
    volume: const LocalNamedModel(id: '0000', name: '第1弾'),
  );
}
