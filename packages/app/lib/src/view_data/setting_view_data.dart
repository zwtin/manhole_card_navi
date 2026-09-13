import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_view_data.freezed.dart';

@freezed
abstract class SettingViewData with _$SettingViewData {
  const factory SettingViewData({
    @Default('') String appName,
    @Default('') String appVersion,
  }) = _SettingViewData;
}
