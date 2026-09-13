import 'package:freezed_annotation/freezed_annotation.dart';

import 'list_prefectures_view_data.dart';

part 'manhole_card_list_view_data.freezed.dart';

@freezed
abstract class ManholeCardListViewData with _$ManholeCardListViewData {
  const factory ManholeCardListViewData({
    required ListPrefecturesViewData prefectures,

    /// 全カードの枚数（絞り込み前）。
    required int totalCount,

    /// 取得済みカードの枚数（絞り込み前）。
    required int alreadyGetCount,

    /// 有効な絞り込みの数。検索ボタンのバッジ表示に使う。
    required int activeFilterCount,
  }) = _ManholeCardListViewData;
  const ManholeCardListViewData._();

  String get navigationTitle => 'リスト　$alreadyGetCount/$totalCount';
}
