import 'package:domain/domain.dart';
import 'package:test/test.dart';

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
          distributionStates: allDistributionStates,
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
          displayFilter: DisplayFilter.acquired,
          volumeIds: {'0000', '0001'},
          distributionStates: {
            const ManholeCardDistributionState.stopped(),
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
          const ManholeCardDistributionState.notClear(),
        ),
        isTrue,
      );
      expect(condition.matchesDisplay(alreadyGet: false), isTrue);
    });

    test('配布状態は、選んだ状態だけを通す', () {
      final condition = CommonSearchCondition(
        distributionStates: {
          const ManholeCardDistributionState.distributing(),
        },
      );

      expect(
        condition.matchesDistributionState(
          const ManholeCardDistributionState.distributing(),
        ),
        isTrue,
      );
      expect(
        condition.matchesDistributionState(
          const ManholeCardDistributionState.stopped(),
        ),
        isFalse,
      );
    });

    test('取得状態の絞り込み', () {
      const acquired = CommonSearchCondition(
        displayFilter: DisplayFilter.acquired,
      );
      const unacquired = CommonSearchCondition(
        displayFilter: DisplayFilter.unacquired,
      );

      expect(acquired.matchesDisplay(alreadyGet: true), isTrue);
      expect(acquired.matchesDisplay(alreadyGet: false), isFalse);
      expect(unacquired.matchesDisplay(alreadyGet: true), isFalse);
      expect(unacquired.matchesDisplay(alreadyGet: false), isTrue);
    });
  });

  test('集合の順序が違っても等しい', () {
    final a = CommonSearchCondition(volumeIds: {'0000', '0001'});
    final b = CommonSearchCondition(volumeIds: {'0001', '0000'});

    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
