import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info.freezed.dart';

@freezed
abstract class AppInfo with _$AppInfo {
  const factory AppInfo({
    required String name,
    required String version,
  }) = _AppInfo;
  const AppInfo._();
}
