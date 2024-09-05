import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_marker_view_data.freezed.dart';

@freezed
abstract class MapMarkerViewData with _$MapMarkerViewData {
  const factory MapMarkerViewData({
    required String id,
    required String cardId,
    required Uint8List icon,
    required String imageUrl,
    required double latitude,
    required double longitude,
  }) = _MapMarkerViewData;
  const MapMarkerViewData._();
}
