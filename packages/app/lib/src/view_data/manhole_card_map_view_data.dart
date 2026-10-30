import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/src/view_data/camera_move_view_data.dart';
import 'package:app/src/view_data/map_marker_view_data.dart';

part 'manhole_card_map_view_data.freezed.dart';

@freezed
abstract class ManholeCardMapViewData with _$ManholeCardMapViewData {
  const factory ManholeCardMapViewData({
    required String navigationTitle,

    /// ピンの幅（pt）。
    required double pinWidth,

    @Default(0) int activeFilterCount,
    @Default(false) bool myLocationEnabled,
    @Default(<MapMarkerViewData>[]) List<MapMarkerViewData> markers,

    /// マップタブでカードのモーダル（またはその上の詳細）を表示中か。
    @Default(false) bool isShowingCardModal,

    /// 最後に出したカメラを動かす指示。まだ出していなければ null。
    CameraMoveViewData? cameraMove,
  }) = _ManholeCardMapViewData;
}
