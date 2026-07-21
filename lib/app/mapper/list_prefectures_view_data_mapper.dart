import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '/app/view_data/list_card_view_data.dart';
import '/app/view_data/list_cards_view_data.dart';
import '/app/view_data/list_prefecture_view_data.dart';
import '/app/view_data/list_prefectures_view_data.dart';
import '/domain/entity/search_condition.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/list_card_dto.dart';

class ListPrefecturesViewDataMapper {
  static Future<ListPrefecturesViewData> convertToViewData({
    required List<ListCardDTO> listCardDTOList,
    required List<AlreadyGetCardDTO> alreadyGetCardDTOList,
    required CommonSearchCondition searchCondition,
  }) async {
    final map = <String, dynamic>{};
    map['listCardDTOList'] = listCardDTOList;
    map['alreadyGetCardDTOList'] = alreadyGetCardDTOList;
    map['searchCondition'] = searchCondition;
    return compute(_convert, map);
  }

  static Future<ListPrefecturesViewData> _convert(
    Map<dynamic, dynamic> parameter,
  ) async {
    final listCardDTOList = parameter['listCardDTOList'] as List<ListCardDTO>;
    final alreadyGetCardDTOList =
        parameter['alreadyGetCardDTOList'] as List<AlreadyGetCardDTO>;
    final searchCondition = parameter['searchCondition'] as CommonSearchCondition;

    final alreadyGetIds =
        alreadyGetCardDTOList.map((dto) => dto.cardId).toSet();

    // 弾数・配布状態で絞り込んだ「母集団」。取得状態フィルタ（表示）はこの後で適用
    // する。都道府県ヘッダの分数はこの母集団を基準にする。
    final universe = listCardDTOList
        .where(
          (dto) =>
              searchCondition.matchesVolume(dto.volumeId) &&
              searchCondition.matchesDistributionState(dto.distributionState),
        )
        .toList();

    final prefectureIdList = universe
        .map(
          (listCardDTO) {
            return listCardDTO.prefectureId;
          },
        )
        .toSet()
        .toList();
    final dateFormatter = DateFormat('yyyy/MM/dd');

    final prefectureList = prefectureIdList
        .map(
          (id) {
            final universeInPrefecture =
                universe.where((dto) => dto.prefectureId == id).toList();
            final cardList = universeInPrefecture
                .map(
                  (dto) {
                    final alreadyGet = alreadyGetIds.contains(dto.id);
                    if (!searchCondition.matchesDisplay(
                      alreadyGet: alreadyGet,
                    )) {
                      return null;
                    }
                    return ListCardViewData(
                      id: dto.id,
                      imageUrl: dto.imagePath,
                      alreadyGet: alreadyGet,
                      name: dto.name,
                      volume: dto.volumeName,
                      publicationDate:
                          dateFormatter.format(dto.publicationDate.toLocal()),
                    );
                  },
                )
                .whereType<ListCardViewData>()
                .toList();
            if (cardList.isEmpty) {
              return null;
            }

            final prefectureName = universeInPrefecture.first.prefectureName;

            // 分数の計算（母集団基準）。
            final totalCardsInPrefecture = universeInPrefecture.length;
            final alreadyGetCardsInPrefecture = universeInPrefecture
                .where((dto) => alreadyGetIds.contains(dto.id))
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
