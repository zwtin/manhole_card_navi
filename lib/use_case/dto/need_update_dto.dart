import 'package:freezed_annotation/freezed_annotation.dart';

part 'need_update_dto.freezed.dart';

@freezed
abstract class NeedUpdateDTO with _$NeedUpdateDTO {
  const factory NeedUpdateDTO({
    required bool need,
  }) = _NeedUpdateDTO;
  const NeedUpdateDTO._();
}
