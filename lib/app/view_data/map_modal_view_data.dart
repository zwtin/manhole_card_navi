import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_modal_view_data.freezed.dart';

@freezed
abstract class MapModalViewData with _$MapModalViewData {
  const factory MapModalViewData({
    required String id,
    required double latitude,
    required double longitude,
  }) = _MapModalViewData;
  const MapModalViewData._();
}
