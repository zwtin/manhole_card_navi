import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_view_data.freezed.dart';

@freezed
abstract class AlertViewData implements _$AlertViewData {
  const factory AlertViewData({
    required String title,
    required String message,
    required AlertOKButtonViewData? okButtonViewData,
    required AlertCancelButtonViewData? cancelButtonViewData,
  }) = _AlertViewData;
  const AlertViewData._();
}

@freezed
abstract class AlertOKButtonViewData implements _$AlertOKButtonViewData {
  const factory AlertOKButtonViewData({
    required String title,
    required Future<void> Function() action,
  }) = _AlertOKButtonViewData;
  const AlertOKButtonViewData._();
}

@freezed
abstract class AlertCancelButtonViewData
    implements _$AlertCancelButtonViewData {
  const factory AlertCancelButtonViewData({
    required String title,
    required Future<void> Function() action,
  }) = _AlertCancelButtonViewData;
  const AlertCancelButtonViewData._();
}
