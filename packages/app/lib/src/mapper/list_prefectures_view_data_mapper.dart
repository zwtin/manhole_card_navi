import 'package:intl/intl.dart';

import 'package:app/src/mapper/prefecture_name_mapper.dart';
import 'package:app/src/view_data/list_card_view_data.dart';
import 'package:app/src/view_data/list_prefecture_view_data.dart';
import 'package:domain/domain.dart';

abstract final class ListPrefecturesViewDataMapper {
  static final _dateFormat = DateFormat('yyyy/MM/dd');

  /// [countCards] は都道府県の並びと分数（分母・取得済みの数）に使い、
  /// [visibleCards] は行に出す。取得済みで絞り込んでも分母が変わらないよう、
  /// 呼ぶ側が取得状態でだけ絞り分ける。
  static List<ListPrefectureViewData> toViewData({
    required List<ManholeCard> countCards,
    required List<ManholeCard> visibleCards,
    required Set<String> alreadyGetCardIds,
    required Set<String> expandedPrefectureIds,
  }) {
    final countsByPrefecture = <String, List<ManholeCard>>{};
    for (final card in countCards) {
      countsByPrefecture.putIfAbsent(card.prefecture.id, () => []).add(card);
    }
    final visibleByPrefecture = <String, List<ManholeCard>>{};
    for (final card in visibleCards) {
      visibleByPrefecture.putIfAbsent(card.prefecture.id, () => []).add(card);
    }

    final prefectures = <ListPrefectureViewData>[];
    for (final MapEntry(key: id, value: inPrefecture)
        in countsByPrefecture.entries) {
      final shown = visibleByPrefecture[id];
      if (shown == null) {
        continue;
      }
      prefectures.add(
        ListPrefectureViewData(
          id: id,
          name: PrefectureNameMapper.nameOf(inPrefecture.first.prefecture),
          cards: [
            for (final card in shown)
              _toCard(card, alreadyGet: alreadyGetCardIds.contains(card.id)),
          ],
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
