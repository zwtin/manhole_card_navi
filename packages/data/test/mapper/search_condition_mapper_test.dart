import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/mapper/search_condition_mapper.dart';
import 'package:data/src/model/search_condition_model.dart';
import 'package:domain/domain.dart';

SearchCondition _read(String source) {
  return SearchConditionMapper.toSearchCondition(
    SearchConditionModel.fromJsonString(source),
  );
}

void main() {
  test('保存して読み戻すと同じ条件になる', () {
    final original = SearchCondition(
      common: CommonSearchCondition(
        alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
        volumeIds: {'0000', '0017'},
        distributionStates: {
          DistributionState.distributing,
          DistributionState.notClear,
        },
      ),
      map: const MapSearchCondition(
        coordinateType: MapCoordinateType.position,
        pinSize: MapPinSize.smallest,
      ),
    );

    final source = SearchConditionMapper.toModel(original).toJsonString();

    expect(_read(source), original);
  });

  test('以前のバージョンが保存した形のまま読める（ピンの大きさは中）', () {
    expect(
      _read(
        '{"common":{"displayFilter":"acquired","volumeIds":["0001"],'
        '"distributionStates":["stopped"]},'
        '"map":{"coordinateType":"position"}}',
      ),
      SearchCondition(
        common: CommonSearchCondition(
          alreadyGetFilter: AlreadyGetFilter.alreadyGet,
          volumeIds: {'0001'},
          distributionStates: {DistributionState.stopped},
        ),
        map: const MapSearchCondition(
          coordinateType: MapCoordinateType.position,
        ),
      ),
    );
  });

  test('保存する文字列は以前のバージョンと同じ', () {
    const condition = SearchCondition(
      common: CommonSearchCondition(
        alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
        distributionStates: {DistributionState.notClear},
      ),
      map: MapSearchCondition(
        coordinateType: MapCoordinateType.position,
        pinSize: MapPinSize.largest,
      ),
    );

    expect(SearchConditionMapper.toModel(condition).toJson(), {
      'common': {
        'displayFilter': 'unacquired',
        'volumeIds': <String>[],
        'distributionStates': ['notClear'],
      },
      'map': {'coordinateType': 'position', 'pinSize': 'largest'},
    });
  });

  test('未保存（空文字）なら初期状態', () {
    expect(_read(''), SearchCondition.initial());
  });

  test('壊れた JSON・形の違う JSON は投げる', () {
    expect(() => _read('{not json'), throwsFormatException);
    expect(() => _read('[]'), throwsFormatException);
    expect(
      () => _read('{"common":3}'),
      throwsA(isA<CheckedFromJsonException>()),
    );
  });

  test('知らない値は無視して既定値にする', () {
    final restored = _read(
      '{"common":{"displayFilter":"unknown","volumeIds":["0001",3],'
      '"distributionStates":["distributing","unknown"]},'
      '"map":{"coordinateType":"unknown","pinSize":"unknown"}}',
    );

    expect(restored.common.alreadyGetFilter, AlreadyGetFilter.all);
    expect(restored.common.volumeIds, {'0001'});
    expect(restored.common.distributionStates, {
      DistributionState.distributing,
    });
    expect(restored.map.coordinateType, MapCoordinateType.distribution);
    expect(restored.map.pinSize, MapPinSize.medium);
  });
}
