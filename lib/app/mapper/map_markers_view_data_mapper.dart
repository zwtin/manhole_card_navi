import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

import '/app/view_data/map_marker_view_data.dart';
import '/app/view_data/map_markers_view_data.dart';
import '/gen/assets.gen.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/map_card_dto.dart';

class MapMarkersViewDataMapper {
  static Future<MapMarkersViewData> convertToViewData({
    required List<MapCardDTO> cardDTOList,
    required List<AlreadyGetCardDTO> getDTOList,
  }) async {
    const uuid = Uuid();
    final markersList = await Future.wait(
      cardDTOList.map(
        (dto) async {
          final cardImageOrNull = await img.decodeJpgFile(dto.imagePath);
          final String assetPath;
          switch (dto.distributionState) {
            case DistributionStateDTO.distributing:
              assetPath = Assets.images.frameGreen.path;
            case DistributionStateDTO.stopped:
              assetPath = Assets.images.frameRed.path;
            case DistributionStateDTO.notClear:
              assetPath = Assets.images.frameYellow.path;
          }
          final pinImageOrNull = await _decodeAsset(assetPath);
          final cardImage = cardImageOrNull!;
          final pinImage = pinImageOrNull!;

          img.Image cardThumbnail;
          if (getDTOList.map((e) => e.cardId).contains(dto.id)) {
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
            cardId: dto.id,
            icon: img.encodePng(mergeImage).buffer.asUint8List(),
            latitude: dto.latitude,
            longitude: dto.longitude,
          );
        },
      ).toList(),
    );
    return MapMarkersViewData(list: markersList);
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
