import 'package:data/src/mapper/search_condition_mapper.dart';
import 'package:data/src/model/search_condition_model.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

SearchCondition _read(String source) {
  return SearchConditionMapper.toSearchCondition(
    SearchConditionModel.fromJsonString(source),
  );
}

void main() {
  test('保存して読み戻すと同じ条件になる', () {
    final original = SearchCondition(
      common: CommonSearchCondition(
        displayFilter: DisplayFilter.unacquired,
        volumeIds: {'0000', '0017'},
        distributionStates: {
          ManholeCardDistributionState.distributing,
          ManholeCardDistributionState.notClear,
        },
      ),
      map: const MapSearchCondition(
        coordinateType: MapCoordinateType.position,
      ),
    );

    final source = SearchConditionMapper.toModel(original).toJsonString();

    expect(_read(source), original);
  });

  test('以前のバージョンが保存した形のまま読める', () {
    expect(
      _read(
        '{"common":{"displayFilter":"acquired","volumeIds":["0001"],'
        '"distributionStates":["stopped"]},'
        '"map":{"coordinateType":"position"}}',
      ),
      SearchCondition(
        common: CommonSearchCondition(
          displayFilter: DisplayFilter.acquired,
          volumeIds: {'0001'},
          distributionStates: {ManholeCardDistributionState.stopped},
        ),
        map: const MapSearchCondition(
          coordinateType: MapCoordinateType.position,
        ),
      ),
    );
  });

  test('未保存（空文字）・壊れた JSON・形の違う JSON なら初期状態', () {
    for (final source in ['', '{not json', '[]', '{"common":3}']) {
      expect(_read(source), SearchCondition.initial(), reason: source);
    }
  });

  test('知らない値は無視して既定値にする', () {
    final restored = _read(
      '{"common":{"displayFilter":"unknown","volumeIds":["0001",3],'
      '"distributionStates":["distributing","unknown"]},'
      '"map":{"coordinateType":"unknown"}}',
    );

    expect(restored.common.displayFilter, DisplayFilter.all);
    expect(restored.common.volumeIds, {'0001'});
    expect(
      restored.common.distributionStates,
      {ManholeCardDistributionState.distributing},
    );
    expect(restored.map.coordinateType, MapCoordinateType.distribution);
  });
}
