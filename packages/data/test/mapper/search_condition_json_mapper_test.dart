import 'package:data/src/mapper/search_condition_json_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('往復変換', () {
    test('JSON にして戻すと同じ条件になる', () {
      final original = SearchCondition(
        common: CommonSearchCondition(
          displayFilter: DisplayFilter.unacquired,
          volumeIds: {'0000', '0017'},
          distributionStates: {
            const ManholeCardDistributionState.distributing(),
            const ManholeCardDistributionState.notClear(),
          },
        ),
        map: const MapSearchCondition(
          coordinateType: MapCoordinateType.position,
        ),
      );

      final restored = SearchConditionJsonMapper.fromJsonString(
        SearchConditionJsonMapper.toJsonString(original),
      );

      expect(restored, original);
    });
  });

  group('fromJsonString', () {
    test('未保存（空文字・null）なら初期状態', () {
      expect(
        SearchConditionJsonMapper.fromJsonString(''),
        SearchCondition.initial(),
      );
      expect(
        SearchConditionJsonMapper.fromJsonString(null),
        SearchCondition.initial(),
      );
    });

    test('壊れた JSON なら初期状態', () {
      expect(
        SearchConditionJsonMapper.fromJsonString('{not json'),
        SearchCondition.initial(),
      );
    });

    test('知らない値は無視して既定値にする', () {
      final restored = SearchConditionJsonMapper.fromJsonString(
        '{"common":{"displayFilter":"unknown","volumeIds":["0001",3],'
        '"distributionStates":["distributing","unknown"]},'
        '"map":{"coordinateType":"unknown"}}',
      );

      expect(restored.common.displayFilter, DisplayFilter.all);
      expect(restored.common.volumeIds, {'0001'});
      expect(
        restored.common.distributionStates,
        {const ManholeCardDistributionState.distributing()},
      );
      expect(restored.map.coordinateType, MapCoordinateType.distribution);
    });
  });
}
