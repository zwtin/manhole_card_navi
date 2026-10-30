import 'package:freezed_annotation/freezed_annotation.dart';

part 'licenses_view_data.freezed.dart';

@freezed
abstract class LicensesViewData with _$LicensesViewData {
  const factory LicensesViewData({
    @Default('') String appName,
    @Default('') String appVersion,
  }) = _LicensesViewData;
}
