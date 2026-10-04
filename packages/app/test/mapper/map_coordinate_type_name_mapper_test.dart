import 'package:app/src/mapper/map_coordinate_type_name_mapper.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('マップの見出しは、座標の種類の表示名に「マップ」を付ける', () {
    expect(
      MapCoordinateTypeNameMapper.mapTitleOf(MapCoordinateType.distribution),
      '配布場所マップ',
    );
    expect(
      MapCoordinateTypeNameMapper.mapTitleOf(MapCoordinateType.position),
      '蓋マップ',
    );
  });
}
