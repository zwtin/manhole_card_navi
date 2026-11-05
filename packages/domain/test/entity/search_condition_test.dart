import 'package:test/test.dart';

import 'package:domain/domain.dart';

void main() {
  group('activeFilterCount', () {
    test('絞り込みなしなら 0', () {
      expect(SearchCondition.initial().activeFilterCount, 0);
    });

    test('取得状態・弾数・配布状態をそれぞれ 1 と数え、マップ表示は数えない', () {
      final condition = SearchCondition(
        common: CommonSearchCondition(
          alreadyGetFilter: AlreadyGetFilter.alreadyGet,
          volumeIds: {'0000', '0001'},
          distributionStates: {DistributionState.stopped},
        ),
        map: const MapSearchCondition(
          coordinateType: MapCoordinateType.position,
          pinSize: MapPinSize.largest,
        ),
      );

      expect(condition.activeFilterCount, 3);
    });
  });

  test('集合の順序が違っても等しい', () {
    final a = CommonSearchCondition(volumeIds: {'0000', '0001'});
    final b = CommonSearchCondition(volumeIds: {'0001', '0000'});

    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
