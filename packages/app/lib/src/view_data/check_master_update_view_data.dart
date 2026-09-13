import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_master_update_view_data.freezed.dart';

@freezed
abstract class CheckMasterUpdateViewData with _$CheckMasterUpdateViewData {
  const factory CheckMasterUpdateViewData({
    @Default(false) bool isLoading,
  }) = _CheckMasterUpdateViewData;
}
