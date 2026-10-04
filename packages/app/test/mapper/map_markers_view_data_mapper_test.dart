import 'package:app/src/mapper/map_markers_view_data_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

ManholeCard _card({
  required String id,
  required List<Coordinate> distributionPoints,
  Coordinate position = const Coordinate(latitude: 35.68, longitude: 139.76),
  DistributionState distributionState = DistributionState.distributing,
  Volume volume = const Volume(id: '0011', name: '第12弾'),
}) {
  return ManholeCard(
    id: id,
    position: position,
    name: 'カード',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: distributionState,
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: distributionPoints,
    prefecture: const Prefecture(id: '13', name: '東京都'),
    volume: volume,
  );
}

CardPin _pin(ManholeCard card) => (card: card, coordinate: card.position);

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
    final pins = MapMarkersViewDataMapper.toPins(
      cards,
      MapCoordinateType.position,
    );

    expect(pins.map((pin) => (pin.card.id, pin.coordinate)), [
      ('A', const Coordinate(latitude: 35.68, longitude: 139.76)),
      ('B', const Coordinate(latitude: 35.68, longitude: 139.76)),
    ]);
  });

  test('カードのピンの位置は、その種類の最初のピン。配布地点がなければ null', () {
    expect(
      MapMarkersViewDataMapper.firstPinOf(
        cards[0],
        MapCoordinateType.distribution,
      ),
      const Coordinate(latitude: 35.69, longitude: 139.77),
    );
    expect(
      MapMarkersViewDataMapper.firstPinOf(
        cards[1],
        MapCoordinateType.distribution,
      ),
      isNull,
    );
  });

  test('配布場所では、配布地点の数だけピンを立てる', () {
    final pins = MapMarkersViewDataMapper.toPins(
      cards,
      MapCoordinateType.distribution,
    );

    expect(pins.map((pin) => (pin.card.id, pin.coordinate)), [
      ('A', const Coordinate(latitude: 35.69, longitude: 139.77)),
      ('A', const Coordinate(latitude: 35.70, longitude: 139.78)),
    ]);
  });

  group('selectNearest', () {
    const center = Coordinate(latitude: 35.0, longitude: 135.0);

    CardPin pinAt(String id, double offset) {
      return _pin(
        _card(
          id: id,
          distributionPoints: const [],
          position: Coordinate(latitude: 35.0 + offset, longitude: 135.0),
        ),
      );
    }

    test('中心に近い順に並べ、30 件までにする', () {
      final pins = [for (var i = 0; i < 40; i++) pinAt('$i', (40 - i) * 0.001)];

      final selected = MapMarkersViewDataMapper.selectNearest(
        pins: pins,
        searchCondition: const CommonSearchCondition(),
        alreadyGetCardIds: const {},
        center: center,
      );

      expect(selected.length, 30);
      expect(selected.first.card.id, '39');
    });

    test('遠すぎるピンは外す', () {
      final selected = MapMarkersViewDataMapper.selectNearest(
        pins: [pinAt('near', 0.01), pinAt('far', 10)],
        searchCondition: const CommonSearchCondition(),
        alreadyGetCardIds: const {},
        center: center,
      );

      expect(selected.map((pin) => pin.card.id), ['near']);
    });

    test('絞り込みで外れたピンは、近傍の枠を使わない', () {
      final pins = [
        for (var i = 0; i < 31; i++)
          _pin(
            _card(
              id: 'other$i',
              distributionPoints: const [],
              position: Coordinate(latitude: 35.0 + i * 0.0001, longitude: 135),
              volume: const Volume(id: '0001', name: '第2弾'),
            ),
          ),
        pinAt('target', 0.05),
      ];

      final selected = MapMarkersViewDataMapper.selectNearest(
        pins: pins,
        searchCondition: const CommonSearchCondition(volumeIds: {'0011'}),
        alreadyGetCardIds: const {},
        center: center,
      );

      expect(selected.map((pin) => pin.card.id), ['target']);
    });

    test('取得済みで絞り込む', () {
      final selected = MapMarkersViewDataMapper.selectNearest(
        pins: [pinAt('got', 0.01), pinAt('not', 0.02)],
        searchCondition: const CommonSearchCondition(
          alreadyGetFilter: AlreadyGetFilter.alreadyGet,
        ),
        alreadyGetCardIds: const {'got'},
        center: center,
      );

      expect(selected.map((pin) => pin.card.id), ['got']);
    });
  });
}
