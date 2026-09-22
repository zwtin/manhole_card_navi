import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_policy.freezed.dart';

@freezed
abstract class PrivacyPolicy with _$PrivacyPolicy {
  const factory PrivacyPolicy({
    required String value,
  }) = _PrivacyPolicy;
  const PrivacyPolicy._();
}
