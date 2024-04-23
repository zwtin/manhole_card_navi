import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import '/app/view_data/map_marker_view_data.dart';
import '/app/view_data/map_markers_view_data.dart';
import '/gen/assets.gen.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/map_marker_dto.dart';

class MapMarkersViewDataMapper {
  static Future<MapMarkersViewData> convertToViewData({
    required List<MapMarkerDTO> mapMarkerDTOList,
    required List<AlreadyGetCardDTO> getCardDTOList,
    required List<AlreadyGetCardDTO> originalGetCardDTOList,
    required MapMarkersViewData originalViewData,
  }) async {
    final assetsMap = await _getAssetMap();
    final map = <String, dynamic>{};
    map['mapMarkerDTOList'] = mapMarkerDTOList;
    map['getCardDTOList'] = getCardDTOList;
    map['originalGetCardDTOList'] = originalGetCardDTOList;
    map['originalViewData'] = originalViewData;
    map['assetsMap'] = assetsMap;
    return compute(_convert, map);
  }

  static Future<MapMarkersViewData> _convert(
    Map<dynamic, dynamic> parameter,
  ) async {
    final mapMarkerDTOList =
        parameter['mapMarkerDTOList'] as List<MapMarkerDTO>;
    final getCardDTOList =
        parameter['getCardDTOList'] as List<AlreadyGetCardDTO>;
    final originalGetCardDTOList =
        parameter['originalGetCardDTOList'] as List<AlreadyGetCardDTO>;
    final originalViewData =
        parameter['originalViewData'] as MapMarkersViewData;
    final assetsMap =
        parameter['assetsMap'] as Map<DistributionStateDTO, img.Image>;
    const uuid = Uuid();
    final markersList = await Future.wait(
      mapMarkerDTOList.map(
        (dto) async {
          if (getCardDTOList.map((e) => e.cardId).contains(dto.cardId) &&
              originalGetCardDTOList
                  .map((e) => e.cardId)
                  .contains(dto.cardId) &&
              originalViewData.getByCardId(dto.cardId) != null) {
            final original = originalViewData.getByCardId(dto.cardId)!;

            return MapMarkerViewData(
              id: uuid.v4(),
              cardId: dto.cardId,
              icon: original.icon,
              latitude: dto.latitude,
              longitude: dto.longitude,
            );
          }
          if (!getCardDTOList.map((e) => e.cardId).contains(dto.cardId) &&
              !originalGetCardDTOList
                  .map((e) => e.cardId)
                  .contains(dto.cardId) &&
              originalViewData.getByCardId(dto.cardId) != null) {
            final original = originalViewData.getByCardId(dto.cardId)!;

            return MapMarkerViewData(
              id: uuid.v4(),
              cardId: dto.cardId,
              icon: original.icon,
              latitude: dto.latitude,
              longitude: dto.longitude,
            );
          }
          final cardImageOrNull = await img.decodeJpgFile(dto.imagePath);
          final pinImageOrNull = assetsMap[dto.distributionState];
          final cardImage = cardImageOrNull!;
          final pinImage = pinImageOrNull!;

          img.Image cardThumbnail;
          if (getCardDTOList.map((e) => e.cardId).contains(dto.cardId)) {
            cardThumbnail = img.copyResize(cardImage, width: 130, height: 180);
          } else {
            final tmpCardThumbnail =
                img.copyResize(cardImage, width: 130, height: 180);
            cardThumbnail = img.grayscale(tmpCardThumbnail);
          }

          final pinThumbnail =
              img.copyResize(pinImage, width: 146, height: 221);

          final mergeImage = img.Image(
            width: 146,
            height: 221,
            numChannels: 4,
          );
          img.compositeImage(
            mergeImage,
            pinThumbnail,
          );
          img.compositeImage(
            mergeImage,
            cardThumbnail,
            dstX: 8,
            dstY: 8,
          );

          return MapMarkerViewData(
            id: uuid.v4(),
            cardId: dto.cardId,
            icon: img.encodePng(mergeImage).buffer.asUint8List(),
            latitude: dto.latitude,
            longitude: dto.longitude,
          );
        },
      ).toList(),
    );
    return MapMarkersViewData(list: markersList);
  }

  static Future<Map<DistributionStateDTO, img.Image>> _getAssetMap() async {
    final map = <DistributionStateDTO, img.Image>{};
    await Future.wait(
      DistributionStateDTO.values.map(
        (value) async {
          final String assetPath;
          switch (value) {
            case DistributionStateDTO.distributing:
              assetPath = Assets.images.frameGreen.path;
            case DistributionStateDTO.stopped:
              assetPath = Assets.images.frameRed.path;
            case DistributionStateDTO.notClear:
              assetPath = Assets.images.frameYellow.path;
          }
          final pinImageOrNull = await _decodeAsset(assetPath);
          final pinImage = pinImageOrNull!;
          map[value] = pinImage;
        },
      ),
    );
    return map;
  }

  static Future<img.Image?> _decodeAsset(String path) async {
    final data = await rootBundle.load(path);

    final buffer = await ui.ImmutableBuffer.fromUint8List(
      data.buffer.asUint8List(),
    );

    final id = await ui.ImageDescriptor.encoded(buffer);
    final codec = await id.instantiateCodec(
      targetHeight: id.height,
      targetWidth: id.width,
    );

    final fi = await codec.getNextFrame();

    final uiImage = fi.image;
    final uiBytes = await uiImage.toByteData();

    final image = img.Image.fromBytes(
      width: id.width,
      height: id.height,
      bytes: uiBytes!.buffer,
      numChannels: 4,
    );
    return image;
  }
}
