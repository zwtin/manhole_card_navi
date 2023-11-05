import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/view_data/list_card_view_data.dart';

part 'list_cards_view_data.freezed.dart';

@freezed
abstract class ListCardsViewData with _$ListCardsViewData {
  const factory ListCardsViewData({
    required List<ListCardViewData> list,
  }) = _ListCardsViewData;
  const ListCardsViewData._();

  Iterable<T> expand<T>(Iterable<T> Function(ListCardViewData) toElements) {
    return list.expand(toElements);
  }
}
