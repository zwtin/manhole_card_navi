import 'package:intl/intl.dart';

import 'package:app/src/mapper/prefecture_name_mapper.dart';
import 'package:app/src/view_data/list_card_view_data.dart';
import 'package:app/src/view_data/list_prefecture_view_data.dart';
import 'package:domain/domain.dart';

abstract final class ListPrefecturesViewDataMapper {
  static final _dateFormat = DateFormat('yyyy/MM/dd');

  /// 都道府県の分数は、取得済みで絞り込む前の枚数を分母にする。
  static List<ListPrefectureViewData> toViewData({
    required List<ManholeCard> cards,
    required Set<String> alreadyGetCardIds,
    required CommonSearchCondition searchCondition,
    required Set<String> expandedPrefectureIds,
  }) {
    final byPrefecture = <String, List<ManholeCard>>{};
    for (final card in cards.where(searchCondition.matchesCard)) {
      byPrefecture.putIfAbsent(card.prefecture.id, () => []).add(card);
    }

    final prefectures = <ListPrefectureViewData>[];
    for (final MapEntry(key: id, value: inPrefecture) in byPrefecture.entries) {
      final shown = [
        for (final card in inPrefecture)
          if (searchCondition.matchesAlreadyGet(
            alreadyGet: alreadyGetCardIds.contains(card.id),
          ))
            _toCard(card, alreadyGet: alreadyGetCardIds.contains(card.id)),
      ];
      if (shown.isEmpty) {
        continue;
      }
      prefectures.add(
        ListPrefectureViewData(
          id: id,
          name: PrefectureNameMapper.nameOf(inPrefecture.first.prefecture),
          cards: shown,
          initiallyExpanded: expandedPrefectureIds.contains(id),
          totalCount: inPrefecture.length,
          alreadyGetCount:
              inPrefecture
                  .where((card) => alreadyGetCardIds.contains(card.id))
                  .length,
        ),
      );
    }
    return prefectures;
  }

  static ListCardViewData _toCard(
    ManholeCard card, {
    required bool alreadyGet,
  }) {
    return ListCardViewData(
      id: card.id,
      alreadyGet: alreadyGet,
      name: card.name,
      volume: card.volume.name,
      publicationDate: _dateFormat.format(card.publicationDate.toLocal()),
    );
  }
}
