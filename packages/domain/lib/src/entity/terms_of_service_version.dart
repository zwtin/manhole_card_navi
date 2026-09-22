import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_of_service_version.freezed.dart';

@freezed
abstract class TermsOfServiceVersion with _$TermsOfServiceVersion {
  const factory TermsOfServiceVersion({
    required String value,
  }) = _TermsOfServiceVersion;
}
