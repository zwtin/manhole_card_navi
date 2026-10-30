import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/src/view_data/list_prefecture_view_data.dart';

part 'manhole_card_list_view_data.freezed.dart';

@freezed
abstract class ManholeCardListViewData with _$ManholeCardListViewData {
  const factory ManholeCardListViewData({
    required List<ListPrefectureViewData> prefectures,

    /// 全カードの枚数（絞り込み前）。
    required int totalCount,

    /// 取得済みカードの枚数（絞り込み前）。
    required int alreadyGetCount,

    required int activeFilterCount,
  }) = _ManholeCardListViewData;
  const ManholeCardListViewData._();

  String get navigationTitle => 'リスト　$alreadyGetCount/$totalCount';
}
