import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../view_data/detail_card_view_data.dart';
import 'prefecture_name_mapper.dart';

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
      alreadyGet: alreadyGet,
      name: card.name,
      prefecture: PrefectureNameMapper.nameOf(card.prefecture),
      volume: card.volume.name,
      publicationDate: dateFormatter.format(card.publicationDate.toLocal()),
      distributionPlaceHtml: card.distributionPlaceHtml,
      distributionTimeHtml: card.distributionTimeHtml,
      stockHtml: card.stockHtml,
    );
  }
}
