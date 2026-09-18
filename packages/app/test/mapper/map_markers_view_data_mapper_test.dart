import 'package:app/src/mapper/map_markers_view_data_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

ManholeCard _card({
  required String id,
  required List<ManholeCardDistributionPoint> distributionPoints,
}) {
  return ManholeCard(
    id: id,
    latitude: 35.68,
    longitude: 139.76,
    name: 'カード',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: ManholeCardDistributionState.distributing,
    image: '',
    imageSub: '',
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: distributionPoints,
    prefecture: const ManholeCardPrefecture(id: '13', name: '東京都'),
    volume: const ManholeCardVolume(id: '0011', name: '第12弾'),
  );
}

void main() {
  final cards = [
    _card(
      id: 'A',
      distributionPoints: const [
        ManholeCardDistributionPoint(latitude: 35.69, longitude: 139.77),
        ManholeCardDistributionPoint(latitude: 35.70, longitude: 139.78),
      ],
    ),
    _card(id: 'B', distributionPoints: const []),
  ];

  test('蓋の位置では、カード 1 枚に 1 本、カードの座標にピンを立てる', () {
    final pins = MapMarkersViewDataMapper.pinsOf(
      cards,
      MapCoordinateType.position,
    );

    expect(
      pins.map((pin) => (pin.card.id, pin.latitude, pin.longitude)),
      [('A', 35.68, 139.76), ('B', 35.68, 139.76)],
    );
  });

  test('配布場所では、配布地点の数だけピンを立てる', () {
    final pins = MapMarkersViewDataMapper.pinsOf(
      cards,
      MapCoordinateType.distribution,
    );

    expect(
      pins.map((pin) => (pin.card.id, pin.latitude, pin.longitude)),
      [('A', 35.69, 139.77), ('A', 35.70, 139.78)],
    );
  });
}
