import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_policy_view_data.freezed.dart';

@freezed
abstract class PrivacyPolicyViewData with _$PrivacyPolicyViewData {
  const factory PrivacyPolicyViewData({@Default('') String html}) =
      _PrivacyPolicyViewData;
}
