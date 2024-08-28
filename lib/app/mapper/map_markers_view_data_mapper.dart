import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '/app/view_data/map_marker_view_data.dart';
import '/app/view_data/map_markers_view_data.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/map_marker_dto.dart';

class MapMarkersViewDataMapper {
  static Map<String, Uint8List> cache = <String, Uint8List>{};

  static Future<MapMarkersViewData> convertToViewData({
    required List<MapMarkerDTO> mapMarkerDTOList,
    required List<AlreadyGetCardDTO> getCardDTOList,
    required List<AlreadyGetCardDTO> originalGetCardDTOList,
    required MapMarkersViewData originalViewData,
    required LatLng coordinate,
  }) async {
    final map = <String, dynamic>{};
    map['mapMarkerDTOList'] = mapMarkerDTOList;
    map['coordinate'] = coordinate;
    return compute(_convert, map);
  }

  static Future<MapMarkersViewData> _convert(
    Map<dynamic, dynamic> parameter,
  ) async {
    final mapMarkerDTOList =
        parameter['mapMarkerDTOList'] as List<MapMarkerDTO>;
    final coordinate = parameter['coordinate'] as LatLng;

    final tmpDTOList = mapMarkerDTOList.where((dto) {
      final latitude = dto.latitude - coordinate.latitude;
      final longitude = dto.longitude - coordinate.longitude;

      final distance = latitude * latitude + longitude * longitude;

      return distance < 1;
    }).toList();

    tmpDTOList.sort((dto1, dto2) {
      final latitude1 = dto1.latitude - coordinate.latitude;
      final longitude1 = dto1.longitude - coordinate.longitude;
      final latitude2 = dto2.latitude - coordinate.latitude;
      final longitude2 = dto2.longitude - coordinate.longitude;

      final distance1 = latitude1 * latitude1 + longitude1 * longitude1;
      final distance2 = latitude2 * latitude2 + longitude2 * longitude2;

      return distance1.compareTo(distance2);
    });

    final takedList = tmpDTOList.take(50);

    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();

    final markersList = await Future.wait(
      takedList.map(
        (dto) async {
          final imageUrl =
              "https://storage.googleapis.com/manhole-card-navi-dev.appspot.com/images/${dto.imagePath}";
          Uint8List icon = Uint8List(0);
          if (cache[imageUrl] != null) {
            icon = cache[imageUrl]!;
          } else {
            final response = await http.get(Uri.parse(imageUrl));
            icon = response.bodyBytes;
            cache[imageUrl] = icon;
          }
          return MapMarkerViewData(
            id: List.generate(8, (_) => charset[random.nextInt(charset.length)])
                .join(),
            cardId: dto.cardId,
            icon: icon,
            latitude: dto.latitude,
            longitude: dto.longitude,
          );
        },
      ).toList(),
    );
    return MapMarkersViewData(list: markersList);
  }
}
