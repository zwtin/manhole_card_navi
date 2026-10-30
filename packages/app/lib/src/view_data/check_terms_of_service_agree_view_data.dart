import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_terms_of_service_agree_view_data.freezed.dart';

@freezed
abstract class CheckTermsOfServiceAgreeViewData
    with _$CheckTermsOfServiceAgreeViewData {
  const factory CheckTermsOfServiceAgreeViewData({
    @Default(false) bool isLoading,
    @Default(false) bool isAgreed,
  }) = _CheckTermsOfServiceAgreeViewData;
}
