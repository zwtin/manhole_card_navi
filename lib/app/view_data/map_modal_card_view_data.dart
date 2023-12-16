import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/view_data/map_modal_contact_view_data.dart';

part 'map_modal_card_view_data.freezed.dart';

@freezed
abstract class MapModalCardViewData with _$MapModalCardViewData {
  const factory MapModalCardViewData({
    required String id,
    required String name,
    required List<MapModalContactViewData> contacts,
    required String distributionLinkText,
    required String distributionLinkUrl,
    required String distributionText,
    required String distributionOther,
    required double latitude,
    required double longitude,
  }) = _MapModalCardViewData;
  const MapModalCardViewData._();
}
