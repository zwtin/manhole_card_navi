import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/view_data/map_marker_view_data.dart';

part 'map_markers_view_data.freezed.dart';

@freezed
abstract class MapMarkersViewData with _$MapMarkersViewData {
  const factory MapMarkersViewData({
    required List<MapMarkerViewData> list,
  }) = _MapMarkersViewData;
  const MapMarkersViewData._();

  Iterable<T> map<T>(T Function(MapMarkerViewData) toElement) {
    return list.map(toElement);
  }

  MapMarkersViewData added(MapMarkerViewData value) {
    final newList = list;
    newList.add(value);
    return MapMarkersViewData(list: newList);
  }

  MapMarkerViewData? getByMarkerId(String markerId) {
    return list.where((element) => element.id == markerId).firstOrNull;
  }

  MapMarkerViewData? getByCardId(String cardId) {
    return list.where((element) => element.cardId == cardId).firstOrNull;
  }
}
