import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_of_service.freezed.dart';

@freezed
abstract class TermsOfService with _$TermsOfService {
  const factory TermsOfService({
    required String value,
  }) = _TermsOfService;
  const TermsOfService._();
}
