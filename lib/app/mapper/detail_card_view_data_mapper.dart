import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '/app/view_data/detail_card_view_data.dart';
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

    final dateFormatter = DateFormat('yyyy/MM/dd');

    return DetailCardViewData(
      id: cardDTO.id,
      imageUrl: cardDTO.imagePath,
      alreadyGet: alreadyGet,
      name: cardDTO.name,
      prefecture: cardDTO.prefectureName,
      volume: cardDTO.volumeName,
      publicationDate: dateFormatter.format(cardDTO.publicationDate.toLocal()),
      distributionPlaceHtml: cardDTO.distributionPlaceHtml,
      distributionTimeHtml: cardDTO.distributionTimeHtml,
      stockHtml: cardDTO.stockHtml,
    );
  }
}
