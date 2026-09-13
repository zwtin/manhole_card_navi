import 'package:freezed_annotation/freezed_annotation.dart';

part 'need_master_update_dto.freezed.dart';

@freezed
abstract class NeedMasterUpdateDTO with _$NeedMasterUpdateDTO {
  const factory NeedMasterUpdateDTO({
    required bool value,
  }) = _NeedMasterUpdateDTO;
  const NeedMasterUpdateDTO._();
}
