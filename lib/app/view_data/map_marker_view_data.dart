import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_marker_view_data.freezed.dart';

@freezed
abstract class MapMarkerViewData with _$MapMarkerViewData {
  const factory MapMarkerViewData({
    required String id,
    required String title,
    required String pinImagePath,
    required String cardImagePath,
    required double latitude,
    required double longitude,
  }) = _MapMarkerViewData;
  const MapMarkerViewData._();
}
