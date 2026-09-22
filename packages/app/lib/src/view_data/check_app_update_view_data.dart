import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_app_update_view_data.freezed.dart';

@freezed
abstract class CheckAppUpdateViewData with _$CheckAppUpdateViewData {
  const factory CheckAppUpdateViewData({
    @Default(false) bool isLoading,
  }) = _CheckAppUpdateViewData;
}
