import 'package:freezed_annotation/freezed_annotation.dart';

part 'agreed_terms_of_service_version.freezed.dart';

@freezed
abstract class AgreedTermsOfServiceVersion with _$AgreedTermsOfServiceVersion {
  const factory AgreedTermsOfServiceVersion({
    required String value,
  }) = _AgreedTermsOfServiceVersion;
  const AgreedTermsOfServiceVersion._();
}
