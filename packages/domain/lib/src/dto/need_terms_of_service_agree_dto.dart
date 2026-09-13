import 'package:freezed_annotation/freezed_annotation.dart';

part 'need_terms_of_service_agree_dto.freezed.dart';

@freezed
abstract class NeedTermsOfServiceAgreeDTO with _$NeedTermsOfServiceAgreeDTO {
  const factory NeedTermsOfServiceAgreeDTO({
    required bool value,
  }) = _NeedTermsOfServiceAgreeDTO;
  const NeedTermsOfServiceAgreeDTO._();
}
