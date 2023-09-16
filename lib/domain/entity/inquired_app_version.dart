import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquired_app_version.freezed.dart';

@freezed
abstract class InquiredAppVersion implements _$InquiredAppVersion {
  const factory InquiredAppVersion({
    required String version,
  }) = _InquiredAppVersion;
  const InquiredAppVersion._();
}
