import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_version.dart';

part 'app_info.freezed.dart';

@freezed
abstract class AppInfo with _$AppInfo {
  const factory AppInfo({
    required String name,
    required AppVersion version,
  }) = _AppInfo;
  const AppInfo._();
}
