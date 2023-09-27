import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_marker_view_data.freezed.dart';

@freezed
abstract class MapMarkerViewData with _$MapMarkerViewData {
  const factory MapMarkerViewData({
    required String id,
    required String title,
    required String imagePath,
    required double latitude,
    required double longitude,
    required MapMarkerFrameState state,
  }) = _MapMarkerViewData;
  const MapMarkerViewData._();
}

enum MapMarkerFrameState {
  distributing,
  stopped,
  notClear,
}
