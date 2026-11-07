import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_display_settings.freezed.dart';

/// マップの見せ方。表示するカードは変えない。
@freezed
abstract class MapDisplaySettings with _$MapDisplaySettings {
  const factory MapDisplaySettings({
    @Default(MapCoordinateType.distribution) MapCoordinateType coordinateType,
    @Default(MapPinSize.medium) MapPinSize pinSize,
  }) = _MapDisplaySettings;
}

enum MapCoordinateType {
  /// 配布場所。
  distribution,

  /// 蓋（マンホール）の場所。
  position,
}

/// マップのピンの大きさ。小さい順。
enum MapPinSize { smallest, small, medium, large, largest }
