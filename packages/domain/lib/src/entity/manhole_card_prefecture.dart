import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_prefecture.freezed.dart';

/// カードを発行した都道府県。
@freezed
abstract class ManholeCardPrefecture with _$ManholeCardPrefecture {
  const factory ManholeCardPrefecture({
    required String id,
    required String name,
  }) = _ManholeCardPrefecture;
  const ManholeCardPrefecture._();

  /// どの都道府県にも属さない、国の機関・全国組織のカードか。
  ///
  /// master では都道府県コード 000 の、名前のない都道府県として入っている。
  /// サーバーの都道府県の表にない ID のカードも、名前がないので同じ扱いになる。
  bool get isNationwide => name.isEmpty;
}
