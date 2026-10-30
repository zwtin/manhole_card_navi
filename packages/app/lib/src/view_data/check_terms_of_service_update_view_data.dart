import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_terms_of_service_update_view_data.freezed.dart';

@freezed
abstract class CheckTermsOfServiceUpdateViewData
    with _$CheckTermsOfServiceUpdateViewData {
  const factory CheckTermsOfServiceUpdateViewData({
    @Default(false) bool isLoading,

    /// 利用規約が更新されていて、再同意を求める表示にするか。
    @Default(false) bool inquireUpdate,
    @Default(false) bool isAgreed,
  }) = _CheckTermsOfServiceUpdateViewData;
}
