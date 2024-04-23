import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquired_app_version.freezed.dart';

@freezed
abstract class InquiredAppVersion with _$InquiredAppVersion {
  const factory InquiredAppVersion({
    required String value,
  }) = _InquiredAppVersion;
  const InquiredAppVersion._();
}
