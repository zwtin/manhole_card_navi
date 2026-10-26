import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/src/view_data/camera_move_view_data.dart';
import 'package:app/src/view_data/map_markers_view_data.dart';

part 'manhole_card_map_view_data.freezed.dart';

@freezed
abstract class ManholeCardMapViewData with _$ManholeCardMapViewData {
  const factory ManholeCardMapViewData({
    required String navigationTitle,

    /// 有効な絞り込みの数。検索ボタンのバッジ表示に使う。
    @Default(0) int activeFilterCount,
    @Default(false) bool myLocationEnabled,
    @Default(MapMarkersViewData(list: [])) MapMarkersViewData markers,

    /// マップ表示エリア（ナビゲーションエリアと下タブエリアの間）の高さ。
    @Default(0.0) double mapAreaHeight,

    /// マップタブでカードのモーダル（またはその上の詳細）を表示中か。
    @Default(false) bool isShowingCardModal,

    /// 最後に出したカメラを動かす指示。まだ出していなければ null。
    CameraMoveViewData? cameraMove,
  }) = _ManholeCardMapViewData;
  const ManholeCardMapViewData._();

  /// モーダルの高さ。マップ表示エリアの 2/3 を占め、残り 1/3 がマップとして見える。
  double get modalHeight => mapAreaHeight * 2.0 / 3.0;
}
