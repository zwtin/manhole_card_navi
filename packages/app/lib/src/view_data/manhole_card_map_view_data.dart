import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'map_markers_view_data.dart';

part 'manhole_card_map_view_data.freezed.dart';

@freezed
abstract class ManholeCardMapViewData with _$ManholeCardMapViewData {
  const factory ManholeCardMapViewData({
    @Default(MapCoordinateType.distribution) MapCoordinateType coordinateType,

    /// 有効な絞り込みの数。検索ボタンのバッジ表示に使う。
    @Default(0) int activeFilterCount,
    @Default(false) bool myLocationEnabled,
    @Default(MapMarkersViewData(list: [])) MapMarkersViewData markers,

    /// マップ表示エリア（ナビゲーションエリアと下タブエリアの間）の高さ。
    @Default(0.0) double mapAreaHeight,

    /// マップタブでカードのモーダル（またはその上の詳細）を表示中か。
    @Default(false) bool isShowingCardModal,
  }) = _ManholeCardMapViewData;
  const ManholeCardMapViewData._();

  String get navigationTitle {
    switch (coordinateType) {
      case MapCoordinateType.distribution:
        return '配布場所マップ';
      case MapCoordinateType.position:
        return '蓋マップ';
    }
  }

  /// モーダルの高さ。マップ表示エリアの 2/3 を占め、残り 1/3 がマップとして見える。
  double get modalHeight => mapAreaHeight * 2.0 / 3.0;
}
