import 'package:freezed_annotation/freezed_annotation.dart';

part 'modal_card_view_data.freezed.dart';

@freezed
abstract class ModalCardViewData with _$ModalCardViewData {
  const factory ModalCardViewData({
    required String id,
    required String name,
    required String distributionPlaceHtml,
    required String stockHtml,
    required double latitude,
    required double longitude,
  }) = _ModalCardViewData;
  const ModalCardViewData._();
}
