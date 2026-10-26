import 'package:domain/domain.dart';

/// 座標の種類の表示名。検索条件の選択肢とマップの見出しで同じ名前を使う。
abstract final class MapCoordinateTypeNameMapper {
  static String nameOf(MapCoordinateType type) {
    return switch (type) {
      MapCoordinateType.distribution => '配布場所',
      MapCoordinateType.position => '蓋',
    };
  }

  static String mapTitleOf(MapCoordinateType type) => '${nameOf(type)}マップ';
}
