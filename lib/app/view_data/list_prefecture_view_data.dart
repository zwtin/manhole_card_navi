import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/view_data/list_cards_view_data.dart';

part 'list_prefecture_view_data.freezed.dart';

@freezed
abstract class ListPrefectureViewData with _$ListPrefectureViewData {
  const factory ListPrefectureViewData({
    required String id,
    required String name,
    required ListCardsViewData cards,
    required bool initiallyExpanded,
  }) = _ListPrefectureViewData;
  const ListPrefectureViewData._();
}
