import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_modal_contact_view_data.freezed.dart';

@freezed
abstract class MapModalContactViewData with _$MapModalContactViewData {
  const factory MapModalContactViewData({
    required String id,
    required String name,
    required String nameUrl,
  }) = _MapModalContactViewData;
  const MapModalContactViewData._();
}
