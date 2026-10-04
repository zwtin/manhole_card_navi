import 'dart:typed_data';

import 'package:domain/domain.dart';

import '../view_data/map_marker_view_data.dart';

/// マップに立てるピン 1 本分。どのカードのピンを、どの座標に立てるか。
typedef CardPin = ({ManholeCard card, Coordinate coordinate});

abstract final class MapMarkersViewDataMapper {
  /// 地図に出すピンの上限。多いほど地図が重くなる。
  static const _limit = 30;

  /// 中心からこの距離（緯度経度の差の二乗）までを近傍とみなす。
  static const _nearDistance = 0.1;

  /// 配布場所では配布地点の数だけピンを立てる（配布地点が 0 件のカードには
  /// ピンが立たない）。
  static List<CardPin> toPins(
    List<ManholeCard> cards,
    MapCoordinateType coordinateType,
  ) {
    switch (coordinateType) {
      case MapCoordinateType.position:
        return [
          for (final card in cards) (card: card, coordinate: card.position),
        ];
      case MapCoordinateType.distribution:
        return [
          for (final card in cards)
            for (final point in card.distributionPoints)
              (card: card, coordinate: point),
        ];
    }
  }

  /// 絞り込んでから近傍を選ぶ。先に絞ることで、絞り込みの対象外のカードが
  /// 近傍の枠を消費しないようにする。
  static List<CardPin> selectNearest({
    required List<CardPin> pins,
    required CommonSearchCondition searchCondition,
    required Set<String> alreadyGetCardIds,
    required Coordinate center,
  }) {
    double distanceOf(CardPin pin) {
      final latitude = pin.coordinate.latitude - center.latitude;
      final longitude = pin.coordinate.longitude - center.longitude;
      return latitude * latitude + longitude * longitude;
    }

    final near =
        pins.where((pin) {
            return searchCondition.matchesCard(pin.card) &&
                searchCondition.matchesAlreadyGet(
                  alreadyGet: alreadyGetCardIds.contains(pin.card.id),
                ) &&
                distanceOf(pin) < _nearDistance;
          }).toList()
          ..sort((pin1, pin2) => distanceOf(pin1).compareTo(distanceOf(pin2)));
    return near.take(_limit).toList();
  }

  static MapMarkerViewData toMarker({
    required CardPin pin,
    required Uint8List icon,
  }) {
    return MapMarkerViewData(
      // マーカーの識別子は再生成をまたいで安定させる。ランダムだと GoogleMap が
      // 同一カードを「削除 + 追加」と誤認してちらつく。配布モードでは同一カードが
      // 複数地点に出るため座標も含めて一意にする。
      id:
          '${pin.card.id}_${pin.coordinate.latitude}_'
          '${pin.coordinate.longitude}',
      cardId: pin.card.id,
      icon: icon,
      latitude: pin.coordinate.latitude,
      longitude: pin.coordinate.longitude,
    );
  }
}
