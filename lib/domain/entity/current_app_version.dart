import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_app_version.freezed.dart';

@freezed
abstract class CurrentAppVersion with _$CurrentAppVersion {
  const factory CurrentAppVersion({
    required String version,
  }) = _CurrentAppVersion;
  const CurrentAppVersion._();
}
