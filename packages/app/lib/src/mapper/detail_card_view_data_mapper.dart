import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../view_data/detail_card_view_data.dart';

class DetailCardViewDataMapper {
  static Future<DetailCardViewData> convertToViewData({
    required ManholeCard card,
    required bool alreadyGet,
  }) async {
    final map = <String, dynamic>{};
    map['card'] = card;
    map['alreadyGet'] = alreadyGet;
    return compute(_convert, map);
  }

  static Future<DetailCardViewData> _convert(
    Map<String, dynamic> parameter,
  ) async {
    final card = parameter['card'] as ManholeCard;
    final alreadyGet = parameter['alreadyGet'] as bool;

    final dateFormatter = DateFormat('yyyy/MM/dd');

    return DetailCardViewData(
      id: card.id,
      imageUrl: card.image,
      imageSubUrl: card.imageSub,
      alreadyGet: alreadyGet,
      name: card.name,
      prefecture: card.prefecture.name,
      volume: card.volume.name,
      publicationDate: dateFormatter.format(card.publicationDate.toLocal()),
      distributionPlaceHtml: card.distributionPlaceHtml,
      distributionTimeHtml: card.distributionTimeHtml,
      stockHtml: card.stockHtml,
    );
  }
}
