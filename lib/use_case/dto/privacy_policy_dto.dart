import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_policy_dto.freezed.dart';

@freezed
abstract class PrivacyPolicyDTO with _$PrivacyPolicyDTO {
  const factory PrivacyPolicyDTO({
    required String value,
  }) = _PrivacyPolicyDTO;
  const PrivacyPolicyDTO._();
}
