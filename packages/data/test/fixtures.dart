import 'package:domain/domain.dart';

/// テスト用のカード。
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
    image: 'https://example.com/$id.jpg',
    imageSub: '',
    distributionPlaceHtml: '<p>藤井寺市役所</p>',
    distributionTimeHtml: '<p>9:00〜17:00</p>',
    stockHtml: '<p>あり</p>',
    distributionPoints: distributionPoints,
    prefecture: const Prefecture(id: '027', name: '大阪府'),
    volume: const Volume(id: '0000', name: '第1弾'),
  );
}
