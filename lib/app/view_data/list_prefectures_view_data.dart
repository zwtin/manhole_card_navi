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

  ListPrefectureViewData getByIndex(int index) {
    return list.elementAt(index);
  }

  ListPrefectureViewData? getById(String id) {
    return list.where((element) => element.id == id).firstOrNull;
  }

  ListPrefecturesViewData onExpansionChanged(bool isExpansion, String id) {
    return ListPrefecturesViewData(
        list: list.map((prefecture) {
      if (prefecture.id == id) {
        return prefecture.copyWith(initialOpen: isExpansion);
      } else {
        return prefecture;
      }
    }).toList());
  }
}
