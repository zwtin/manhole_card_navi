import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/view_data/list_card_view_data.dart';

part 'list_cards_view_data.freezed.dart';

@freezed
abstract class ListCardsViewData with _$ListCardsViewData {
  const factory ListCardsViewData({
    required List<ListCardViewData> list,
  }) = _ListCardsViewData;
  const ListCardsViewData._();

  Iterable<T> map<T>(T Function(ListCardViewData) toElement) {
    return list.map(toElement);
  }

  ListCardViewData? getById(String id) {
    return list.where((element) => element.id == id).firstOrNull;
  }

  ListCardsViewData where(bool Function(ListCardViewData) test) {
    final filteredList = list.where(test).toList();
    return ListCardsViewData(list: filteredList);
  }

  bool get isEmpty {
    return list.isEmpty;
  }
}
