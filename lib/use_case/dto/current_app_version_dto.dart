import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_app_version_dto.freezed.dart';

@freezed
abstract class CurrentAppVersionDTO with _$CurrentAppVersionDTO {
  const factory CurrentAppVersionDTO({
    required String value,
  }) = _CurrentAppVersionDTO;
  const CurrentAppVersionDTO._();
}
