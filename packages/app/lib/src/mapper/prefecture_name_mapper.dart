import 'package:domain/domain.dart';

/// 都道府県の表示名。
abstract final class PrefectureNameMapper {
  /// 国の機関・全国組織のカードは、都道府県の代わりに「全国」と表示する。
  static String nameOf(Prefecture prefecture) {
    return prefecture.isNationwide ? '全国' : prefecture.name;
  }
}
