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
  static bool converting = false;

  static Future<MapMarkersViewData> convertToViewData({
    required List<MapMarkerDTO> mapMarkerDTOList,
    required List<AlreadyGetCardDTO> alreadyGetCardDTOList,
    required LatLng centerCoordinate,
  }) async {
    if (converting) {
      return const MapMarkersViewData(list: []);
    }
    converting = true;
    final map = <String, dynamic>{};
    map['mapMarkerDTOList'] = mapMarkerDTOList;
    map['alreadyGetCardDTOList'] = alreadyGetCardDTOList;
    map['centerCoordinate'] = centerCoordinate;
    map['cache'] = cache;
    final viewData = await compute(_convert, map);
    viewData.forEach((element) {
      cache[element.imageUrl] = element.icon;
    });
    converting = false;
    return viewData;
  }

  static Future<MapMarkersViewData> _convert(
    Map<dynamic, dynamic> parameter,
  ) async {
    final mapMarkerDTOList =
        parameter['mapMarkerDTOList'] as List<MapMarkerDTO>;
    final alreadyGetCardDTOList =
        parameter['alreadyGetCardDTOList'] as List<AlreadyGetCardDTO>;
    final centerCoordinate = parameter['centerCoordinate'] as LatLng;
    final cache = parameter['cache'] as Map<String, Uint8List>;

    final tmpDTOList = mapMarkerDTOList.where((dto) {
      final latitude = dto.latitude - centerCoordinate.latitude;
      final longitude = dto.longitude - centerCoordinate.longitude;

      final distance = latitude * latitude + longitude * longitude;

      return distance < 0.1;
    }).toList();

    tmpDTOList.sort((dto1, dto2) {
      final latitude1 = dto1.latitude - centerCoordinate.latitude;
      final longitude1 = dto1.longitude - centerCoordinate.longitude;
      final latitude2 = dto2.latitude - centerCoordinate.latitude;
      final longitude2 = dto2.longitude - centerCoordinate.longitude;

      final distance1 = latitude1 * latitude1 + longitude1 * longitude1;
      final distance2 = latitude2 * latitude2 + longitude2 * longitude2;

      return distance1.compareTo(distance2);
    });

    final takedList = tmpDTOList.take(30);

    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();

    final markersList = await Future.wait(
      takedList.map(
        (dto) async {
          final alreadyGet =
              alreadyGetCardDTOList.map((e) => e.cardId).contains(dto.cardId);
          final String imageUrl;
          if (alreadyGet) {
            imageUrl = dto.colorImageUrl;
          } else {
            imageUrl = dto.grayImageUrl;
          }
          final Uint8List icon;
          final fromCache = cache[imageUrl];
          if (fromCache != null) {
            icon = fromCache;
          } else {
            final response = await http.get(Uri.parse(imageUrl));
            icon = response.bodyBytes;
          }
          return MapMarkerViewData(
            id: List.generate(8, (_) => charset[random.nextInt(charset.length)])
                .join(),
            cardId: dto.cardId,
            icon: icon,
            imageUrl: imageUrl,
            latitude: dto.latitude,
            longitude: dto.longitude,
          );
        },
      ).toList(),
    );
    return MapMarkersViewData(list: markersList);
  }
}
