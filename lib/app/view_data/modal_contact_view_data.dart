import 'package:freezed_annotation/freezed_annotation.dart';

part 'modal_contact_view_data.freezed.dart';

@freezed
abstract class ModalContactViewData with _$ModalContactViewData {
  const factory ModalContactViewData({
    required String id,
    required String name,
    required String nameUrl,
  }) = _ModalContactViewData;
  const ModalContactViewData._();
}
