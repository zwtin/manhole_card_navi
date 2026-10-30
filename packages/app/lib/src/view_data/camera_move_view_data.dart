import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_move_view_data.freezed.dart';

/// カメラを動かす指示。View が受け取って地図のカメラを動かす。
@freezed
abstract class CameraMoveViewData with _$CameraMoveViewData {
  const factory CameraMoveViewData({
    /// 指示ごとに振る番号。同じ場所へもう一度動かすときも、別の指示として
    /// View に届くようにする。
    required int id,
    required double latitude,
    required double longitude,
    required bool animated,
  }) = _CameraMoveViewData;
}
