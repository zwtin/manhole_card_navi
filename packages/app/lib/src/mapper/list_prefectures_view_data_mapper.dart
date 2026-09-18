import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../view_data/list_card_view_data.dart';
import '../view_data/list_cards_view_data.dart';
import '../view_data/list_prefecture_view_data.dart';
import '../view_data/list_prefectures_view_data.dart';

class ListPrefecturesViewDataMapper {
  static Future<ListPrefecturesViewData> convertToViewData({
    required List<ManholeCard> cards,
    required Set<String> alreadyGetCardIds,
    required CommonSearchCondition searchCondition,
  }) async {
    final map = <String, dynamic>{};
    map['cards'] = cards;
    map['alreadyGetCardIds'] = alreadyGetCardIds;
    map['searchCondition'] = searchCondition;
    return compute(_convert, map);
  }

  static Future<ListPrefecturesViewData> _convert(
    Map<dynamic, dynamic> parameter,
  ) async {
    final cards = parameter['cards'] as List<ManholeCard>;
    final alreadyGetIds = parameter['alreadyGetCardIds'] as Set<String>;
    final searchCondition = parameter['searchCondition'] as CommonSearchCondition;

    // 弾数・配布状態で絞り込んだ「母集団」。取得状態フィルタ（表示）はこの後で適用
    // する。都道府県ヘッダの分数はこの母集団を基準にする。
    final universe = cards
        .where(
          (card) =>
              searchCondition.matchesVolume(card.volume.id) &&
              searchCondition.matchesDistributionState(card.distributionState),
        )
        .toList();

    final prefectureIdList =
        universe.map((card) => card.prefecture.id).toSet().toList();
    final dateFormatter = DateFormat('yyyy/MM/dd');

    final prefectureList = prefectureIdList
        .map(
          (id) {
            final universeInPrefecture =
                universe.where((card) => card.prefecture.id == id).toList();
            final cardList = universeInPrefecture
                .map(
                  (card) {
                    final alreadyGet = alreadyGetIds.contains(card.id);
                    if (!searchCondition.matchesDisplay(
                      alreadyGet: alreadyGet,
                    )) {
                      return null;
                    }
                    return ListCardViewData(
                      id: card.id,
                      imageUrl: card.image,
                      imageSubUrl: card.imageSub,
                      alreadyGet: alreadyGet,
                      name: card.name,
                      volume: card.volume.name,
                      publicationDate:
                          dateFormatter.format(card.publicationDate.toLocal()),
                    );
                  },
                )
                .whereType<ListCardViewData>()
                .toList();
            if (cardList.isEmpty) {
              return null;
            }

            final prefectureName = universeInPrefecture.first.prefecture.name;

            // 分数の計算（母集団基準）。
            final totalCardsInPrefecture = universeInPrefecture.length;
            final alreadyGetCardsInPrefecture = universeInPrefecture
                .where((card) => alreadyGetIds.contains(card.id))
                .length;

            return ListPrefectureViewData(
              id: id,
              name: prefectureName.isEmpty ? '全国' : prefectureName,
              cards: ListCardsViewData(
                list: cardList,
              ),
              initiallyExpanded: false,
              totalCount: totalCardsInPrefecture,
              alreadyGetCount: alreadyGetCardsInPrefecture,
            );
          },
        )
        .whereType<ListPrefectureViewData>()
        .toList();
    return ListPrefecturesViewData(list: prefectureList);
  }
}
