import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:data/src/mapper/card_browsing_settings_mapper.dart';
import 'package:data/src/model/search_condition_model.dart';
import 'package:domain/domain.dart';

CardBrowsingSettings _read(String source) {
  return CardBrowsingSettingsMapper.toCardBrowsingSettings(
    SearchConditionModel.fromJsonString(source),
  );
}

void main() {
  test('保存して読み戻すと同じ条件になる', () {
    final original = CardBrowsingSettings(
      searchCondition: SearchCondition(
        alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
        volumeIds: {'0000', '0017'},
        distributionStates: {
          DistributionState.distributing,
          DistributionState.notClear,
        },
      ),
      mapDisplaySettings: const MapDisplaySettings(
        coordinateType: MapCoordinateType.position,
        pinSize: MapPinSize.smallest,
      ),
    );

    final source = CardBrowsingSettingsMapper.toModel(original).toJsonString();

    expect(_read(source), original);
  });

  test('以前のバージョンが保存した形のまま読める（ピンの大きさは中）', () {
    expect(
      _read(
        '{"common":{"displayFilter":"acquired","volumeIds":["0001"],'
        '"distributionStates":["stopped"]},'
        '"map":{"coordinateType":"position"}}',
      ),
      CardBrowsingSettings(
        searchCondition: SearchCondition(
          alreadyGetFilter: AlreadyGetFilter.alreadyGet,
          volumeIds: {'0001'},
          distributionStates: {DistributionState.stopped},
        ),
        mapDisplaySettings: const MapDisplaySettings(
          coordinateType: MapCoordinateType.position,
        ),
      ),
    );
  });

  test('保存する文字列は以前のバージョンと同じ', () {
    const settings = CardBrowsingSettings(
      searchCondition: SearchCondition(
        alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
        distributionStates: {DistributionState.notClear},
      ),
      mapDisplaySettings: MapDisplaySettings(
        coordinateType: MapCoordinateType.position,
        pinSize: MapPinSize.largest,
      ),
    );

    expect(CardBrowsingSettingsMapper.toModel(settings).toJson(), {
      'common': {
        'displayFilter': 'unacquired',
        'volumeIds': <String>[],
        'distributionStates': ['notClear'],
      },
      'map': {'coordinateType': 'position', 'pinSize': 'largest'},
    });
  });

  test('未保存（空文字）なら初期状態', () {
    expect(_read(''), CardBrowsingSettings.initial());
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

    expect(restored.searchCondition.alreadyGetFilter, AlreadyGetFilter.all);
    expect(restored.searchCondition.volumeIds, {'0001'});
    expect(restored.searchCondition.distributionStates, {
      DistributionState.distributing,
    });
    expect(
      restored.mapDisplaySettings.coordinateType,
      MapCoordinateType.distribution,
    );
    expect(restored.mapDisplaySettings.pinSize, MapPinSize.medium);
  });
}
