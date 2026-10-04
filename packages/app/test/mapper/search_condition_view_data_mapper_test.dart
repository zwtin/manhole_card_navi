import 'package:app/src/mapper/search_condition_view_data_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('選択肢は値をすべて並べる', () {
    // 足りないと、押された番号で戻せない値ができる。
    expect(
      SearchConditionViewDataMapper.alreadyGetFilters.toSet(),
      AlreadyGetFilter.values.toSet(),
    );
    expect(
      SearchConditionViewDataMapper.distributionStates.toSet(),
      DistributionState.values.toSet(),
    );
    expect(
      SearchConditionViewDataMapper.coordinateTypes.toSet(),
      MapCoordinateType.values.toSet(),
    );
  });

  test('ドラフトで選ばれているものに印が付く', () {
    const draft = SearchCondition(
      common: CommonSearchCondition(
        alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
        volumeIds: {'0001'},
        distributionStates: {DistributionState.stopped},
      ),
      map: MapSearchCondition(coordinateType: MapCoordinateType.position),
    );

    final viewData = SearchConditionViewDataMapper.toViewData(
      draft: draft,
      volumes: const [
        Volume(id: '0001', name: '第2弾'),
        Volume(id: '0000', name: '第1弾'),
      ],
    );

    expect(viewData.alreadyGetFilters, [
      (label: 'すべて', selected: false),
      (label: '取得済みのみ', selected: false),
      (label: '未取得のみ', selected: true),
    ]);
    expect(viewData.volumes, [
      (label: '第2弾', selected: true),
      (label: '第1弾', selected: false),
    ]);
    expect(viewData.distributionStates, [
      (label: '配布中', selected: false),
      (label: '配布停止', selected: true),
      (label: '不明', selected: false),
    ]);
    expect(viewData.coordinateTypes, [
      (label: '配布場所', selected: false),
      (label: '蓋', selected: true),
    ]);
  });
}
