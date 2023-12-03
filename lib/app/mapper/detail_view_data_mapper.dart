import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

import '/app/view_data/detail_card_view_data.dart';
import '/app/view_data/detail_contact_view_data.dart';
import '/use_case/dto/card_dto.dart';

class DetailViewDataMapper {
  static Future<DetailCardViewData> convertToViewData({
    required CardDTO cardDTO,
  }) async {
    final cardImageOrNull = await img.decodeJpgFile(cardDTO.imagePath);
    final cardImage = cardImageOrNull!;

    final dateFormatter = DateFormat('yyyy/MM/dd');

    return DetailCardViewData(
      id: cardDTO.id,
      icon: img.encodePng(cardImage).buffer.asUint8List(),
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
      distributionText: cardDTO.distributionText,
      distributionUrl: cardDTO.distributionUrl,
    );
  }
}
