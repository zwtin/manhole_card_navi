import 'package:intl/intl.dart';

import 'package:app/src/mapper/prefecture_name_mapper.dart';
import 'package:app/src/view_data/detail_card_view_data.dart';
import 'package:domain/domain.dart';

abstract final class DetailCardViewDataMapper {
  static final _dateFormat = DateFormat('yyyy/MM/dd');

  static DetailCardViewData toViewData({
    required ManholeCard card,
    required bool alreadyGet,
  }) {
    return DetailCardViewData(
      id: card.id,
      alreadyGet: alreadyGet,
      name: card.name,
      prefecture: PrefectureNameMapper.nameOf(card.prefecture),
      volume: card.volume.name,
      publicationDate: _dateFormat.format(card.publicationDate.toLocal()),
      distributionPlaceHtml: card.distributionPlaceHtml,
      distributionTimeHtml: card.distributionTimeHtml,
      stockHtml: card.stockHtml,
    );
  }
}
