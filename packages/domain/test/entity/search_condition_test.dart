import 'package:test/test.dart';

import 'package:domain/domain.dart';

void main() {
  group('normalized', () {
    test('すべての弾を選んだ状態は、未選択（すべて表示）に畳む', () {
      final condition = SearchCondition(
        common: CommonSearchCondition(volumeIds: {'0000', '0001'}),
      );

      final normalized = condition.normalized(allVolumeIds: {'0000', '0001'});

      expect(normalized.common.volumeIds, isEmpty);
    });

    test('一部の弾だけを選んだ状態はそのまま残す', () {
      final condition = SearchCondition(
        common: CommonSearchCondition(volumeIds: {'0000'}),
      );

      final normalized = condition.normalized(allVolumeIds: {'0000', '0001'});

      expect(normalized.common.volumeIds, {'0000'});
    });

    test('すべての配布状態を選んだ状態は、未選択に畳む', () {
      final condition = SearchCondition(
        common: CommonSearchCondition(
          distributionStates: DistributionState.values.toSet(),
        ),
      );

      final normalized = condition.normalized(allVolumeIds: const {});

      expect(normalized.common.distributionStates, isEmpty);
    });
  });

  group('activeFilterCount', () {
    test('絞り込みなしなら 0', () {
      expect(SearchCondition.initial().activeFilterCount, 0);
    });

    test('取得状態・弾数・配布状態をそれぞれ 1 と数え、マップ表示は数えない', () {
      final condition = SearchCondition(
        common: CommonSearchCondition(
          alreadyGetFilter: AlreadyGetFilter.alreadyGet,
          volumeIds: {'0000', '0001'},
          distributionStates: {
            DistributionState.stopped,
          },
        ),
        map: const MapSearchCondition(
          coordinateType: MapCoordinateType.position,
        ),
      );

      expect(condition.activeFilterCount, 3);
    });
  });

  group('CommonSearchCondition の判定', () {
    test('未選択の軸はすべて通す', () {
      const condition = CommonSearchCondition();

      expect(condition.matchesVolume('0005'), isTrue);
      expect(
        condition.matchesDistributionState(
          DistributionState.notClear,
        ),
        isTrue,
      );
      expect(condition.matchesAlreadyGet(alreadyGet: false), isTrue);
    });

    test('配布状態は、選んだ状態だけを通す', () {
      final condition = CommonSearchCondition(
        distributionStates: {
          DistributionState.distributing,
        },
      );

      expect(
        condition.matchesDistributionState(
          DistributionState.distributing,
        ),
        isTrue,
      );
      expect(
        condition.matchesDistributionState(
          DistributionState.stopped,
        ),
        isFalse,
      );
    });

    test('取得状態の絞り込み', () {
      const alreadyGet = CommonSearchCondition(
        alreadyGetFilter: AlreadyGetFilter.alreadyGet,
      );
      const notAlreadyGet = CommonSearchCondition(
        alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
      );

      expect(alreadyGet.matchesAlreadyGet(alreadyGet: true), isTrue);
      expect(alreadyGet.matchesAlreadyGet(alreadyGet: false), isFalse);
      expect(notAlreadyGet.matchesAlreadyGet(alreadyGet: true), isFalse);
      expect(notAlreadyGet.matchesAlreadyGet(alreadyGet: false), isTrue);
    });
  });

  test('集合の順序が違っても等しい', () {
    final a = CommonSearchCondition(volumeIds: {'0000', '0001'});
    final b = CommonSearchCondition(volumeIds: {'0001', '0000'});

    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
