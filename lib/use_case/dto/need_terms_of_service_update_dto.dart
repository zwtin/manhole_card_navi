import 'package:freezed_annotation/freezed_annotation.dart';

part 'need_terms_of_service_update_dto.freezed.dart';

@freezed
abstract class NeedTermsOfServiceUpdateDTO with _$NeedTermsOfServiceUpdateDTO {
  const factory NeedTermsOfServiceUpdateDTO({
    required bool value,
  }) = _NeedTermsOfServiceUpdateDTO;
  const NeedTermsOfServiceUpdateDTO._();
}
