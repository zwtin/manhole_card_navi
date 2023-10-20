import 'package:freezed_annotation/freezed_annotation.dart';

part 'first_open_dto.freezed.dart';

@freezed
abstract class FirstOpenDTO with _$FirstOpenDTO {
  const factory FirstOpenDTO({
    required bool isFirst,
  }) = _FirstOpenDTO;
  const FirstOpenDTO._();
}
