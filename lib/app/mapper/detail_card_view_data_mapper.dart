import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

import '/app/view_data/detail_card_view_data.dart';
import '/app/view_data/detail_contact_view_data.dart';
import '/use_case/dto/card_dto.dart';

class DetailCardViewDataMapper {
  static Future<DetailCardViewData> convertToViewData({
    required CardDTO cardDTO,
    required bool alreadyGet,
  }) async {
    final map = <String, dynamic>{};
    map['cardDTO'] = cardDTO;
    map['alreadyGet'] = alreadyGet;
    return compute(_convert, map);
  }

  static Future<DetailCardViewData> _convert(
    Map<String, dynamic> parameter,
  ) async {
    final cardDTO = parameter['cardDTO'] as CardDTO;
    final alreadyGet = parameter['alreadyGet'] as bool;
    final cardImageOrNull = await img.decodeJpgFile(cardDTO.imagePath);
    final cardImage = img.copyResize(cardImageOrNull!, width: 260, height: 360);
    img.Image cardThumbnail;
    if (alreadyGet) {
      cardThumbnail = cardImage;
    } else {
      cardThumbnail = img.grayscale(cardImage);
    }

    final dateFormatter = DateFormat('yyyy/MM/dd');

    return DetailCardViewData(
      id: cardDTO.id,
      icon: img.encodePng(cardThumbnail).buffer.asUint8List(),
      name: cardDTO.name,
      prefecture: cardDTO.prefectureName,
      volume: cardDTO.volumeName,
      publicationDate: dateFormatter.format(cardDTO.publicationDate),
      contacts: cardDTO.contacts.map(
        (contactDTO) {
          return DetailContactViewData(
            id: contactDTO.id,
            name: contactDTO.name,
            nameUrl: contactDTO.nameUrl,
            address: contactDTO.address,
            phoneNumber: contactDTO.phoneNumber,
            other: contactDTO.other,
            time: contactDTO.time,
            timeOther: contactDTO.timeOther,
          );
        },
      ).toList(),
      distributionLinkText: cardDTO.distributionLinkText,
      distributionLinkUrl: cardDTO.distributionLinkUrl,
      distributionText: cardDTO.distributionText,
      distributionOther: cardDTO.distributionOther,
    );
  }
}
