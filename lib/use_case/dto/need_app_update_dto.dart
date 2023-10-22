import 'package:freezed_annotation/freezed_annotation.dart';

part 'need_app_update_dto.freezed.dart';

@freezed
abstract class NeedAppUpdateDTO with _$NeedAppUpdateDTO {
  const factory NeedAppUpdateDTO({
    required bool value,
  }) = _NeedAppUpdateDTO;
  const NeedAppUpdateDTO._();
}
