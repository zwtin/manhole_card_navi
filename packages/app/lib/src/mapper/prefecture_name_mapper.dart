import 'package:domain/domain.dart';

/// 都道府県の表示名。
class PrefectureNameMapper {
  const PrefectureNameMapper._();

  /// 国の機関・全国組織のカードは、都道府県の代わりに「全国」と表示する。
  static String nameOf(ManholeCardPrefecture prefecture) {
    return prefecture.isNationwide ? '全国' : prefecture.name;
  }
}
