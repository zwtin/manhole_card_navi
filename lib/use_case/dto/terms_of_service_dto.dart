import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_of_service_dto.freezed.dart';

@freezed
abstract class TermsOfServiceDTO with _$TermsOfServiceDTO {
  const factory TermsOfServiceDTO({
    required String value,
  }) = _TermsOfServiceDTO;
  const TermsOfServiceDTO._();
}
