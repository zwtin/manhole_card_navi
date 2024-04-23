import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/view_data/list_prefecture_view_data.dart';

part 'list_prefectures_view_data.freezed.dart';

@freezed
abstract class ListPrefecturesViewData with _$ListPrefecturesViewData {
  const factory ListPrefecturesViewData({
    required List<ListPrefectureViewData> list,
  }) = _ListPrefecturesViewData;
  const ListPrefecturesViewData._();

  int get length => list.length;

  bool get isEmpty => list.isEmpty;

  ListPrefectureViewData getByIndex(int index) {
    return list.elementAt(index);
  }

  ListPrefectureViewData? getById(String id) {
    return list.where((element) => element.id == id).firstOrNull;
  }

  ListPrefecturesViewData where(bool Function(ListPrefectureViewData) test) {
    final filteredList = list.where(test).toList();
    return ListPrefecturesViewData(list: filteredList);
  }

  ListPrefecturesViewData onExpandedChanged(bool initiallyExpanded, String id) {
    return ListPrefecturesViewData(
        list: list.map((prefecture) {
      if (prefecture.id == id) {
        return prefecture.copyWith(initiallyExpanded: initiallyExpanded);
      } else {
        return prefecture;
      }
    }).toList());
  }
}
