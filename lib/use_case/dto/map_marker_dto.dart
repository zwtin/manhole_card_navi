import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_marker_dto.freezed.dart';

@freezed
abstract class MapMarkerDTO with _$MapMarkerDTO {
  const factory MapMarkerDTO({
    required String cardId,

    /// カード画像の配信用フル URL（Firestore 格納値をそのまま利用）。
    required String imagePath,
    required String distributionState,

    /// 弾（volume）の ID。弾数による絞り込みに使う。
    required String volumeId,
    required double latitude,
    required double longitude,
  }) = _MapMarkerDTO;
  const MapMarkerDTO._();
}
