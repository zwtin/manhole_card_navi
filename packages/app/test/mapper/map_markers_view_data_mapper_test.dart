import 'package:app/src/mapper/map_markers_view_data_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

ManholeCard _card({
  required String id,
  required List<Coordinate> distributionPoints,
}) {
  return ManholeCard(
    id: id,
    position: const Coordinate(latitude: 35.68, longitude: 139.76),
    name: 'カード',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: DistributionState.distributing,
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: distributionPoints,
    prefecture: const Prefecture(id: '13', name: '東京都'),
    volume: const Volume(id: '0011', name: '第12弾'),
  );
}

void main() {
  final cards = [
    _card(
      id: 'A',
      distributionPoints: const [
        Coordinate(latitude: 35.69, longitude: 139.77),
        Coordinate(latitude: 35.70, longitude: 139.78),
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
      pins.map((pin) => (pin.card.id, pin.coordinate)),
      [
        ('A', const Coordinate(latitude: 35.68, longitude: 139.76)),
        ('B', const Coordinate(latitude: 35.68, longitude: 139.76)),
      ],
    );
  });

  test('配布場所では、配布地点の数だけピンを立てる', () {
    final pins = MapMarkersViewDataMapper.pinsOf(
      cards,
      MapCoordinateType.distribution,
    );

    expect(
      pins.map((pin) => (pin.card.id, pin.coordinate)),
      [
        ('A', const Coordinate(latitude: 35.69, longitude: 139.77)),
        ('A', const Coordinate(latitude: 35.70, longitude: 139.78)),
      ],
    );
  });
}
