import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_first_open_dto.freezed.dart';

@freezed
abstract class IsFirstOpenDTO with _$IsFirstOpenDTO {
  const factory IsFirstOpenDTO({
    required bool value,
  }) = _IsFirstOpenDTO;
  const IsFirstOpenDTO._();
}
