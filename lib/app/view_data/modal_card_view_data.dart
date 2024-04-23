import 'package:freezed_annotation/freezed_annotation.dart';

import '/app/view_data/modal_contact_view_data.dart';

part 'modal_card_view_data.freezed.dart';

@freezed
abstract class ModalCardViewData with _$ModalCardViewData {
  const factory ModalCardViewData({
    required String id,
    required String name,
    required List<ModalContactViewData> contacts,
    required String distributionLinkText,
    required String distributionLinkUrl,
    required String distributionText,
    required String distributionOther,
    required double latitude,
    required double longitude,
  }) = _ModalCardViewData;
  const ModalCardViewData._();
}
