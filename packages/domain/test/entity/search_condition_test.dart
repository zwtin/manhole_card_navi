import 'package:test/test.dart';

import 'package:domain/domain.dart';

void main() {
  group('activeFilterCount', () {
    test('絞り込みなしなら 0', () {
      expect(const SearchCondition().activeFilterCount, 0);
    });

    test('取得状態・弾数・配布状態をそれぞれ 1 と数える', () {
      final condition = SearchCondition(
        alreadyGetFilter: AlreadyGetFilter.alreadyGet,
        volumeIds: {'0000', '0001'},
        distributionStates: {DistributionState.stopped},
      );

      expect(condition.activeFilterCount, 3);
    });
  });

  test('集合の順序が違っても等しい', () {
    final a = SearchCondition(volumeIds: {'0000', '0001'});
    final b = SearchCondition(volumeIds: {'0001', '0000'});

    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
