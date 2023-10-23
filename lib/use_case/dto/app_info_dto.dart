import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info_dto.freezed.dart';

@freezed
abstract class AppInfoDTO with _$AppInfoDTO {
  const factory AppInfoDTO({
    required String name,
    required String version,
  }) = _AppInfoDTO;
  const AppInfoDTO._();
}
