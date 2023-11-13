import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquired_terms_of_service_version.freezed.dart';

@freezed
abstract class InquiredTermsOfServiceVersion
    with _$InquiredTermsOfServiceVersion {
  const factory InquiredTermsOfServiceVersion({
    required String value,
  }) = _InquiredTermsOfServiceVersion;
  const InquiredTermsOfServiceVersion._();
}
