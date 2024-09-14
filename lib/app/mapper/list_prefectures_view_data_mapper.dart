import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '/app/view_data/list_card_view_data.dart';
import '/app/view_data/list_cards_view_data.dart';
import '/app/view_data/list_prefecture_view_data.dart';
import '/app/view_data/list_prefectures_view_data.dart';
import '/app/view_model/manhole_card_list_view_model.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/list_card_dto.dart';

class ListPrefecturesViewDataMapper {
  static Future<ListPrefecturesViewData> convertToViewData({
    required List<ListCardDTO> listCardDTOList,
    required List<AlreadyGetCardDTO> alreadyGetCardDTOList,
    required ListState listState,
  }) async {
    final map = <String, dynamic>{};
    map['listCardDTOList'] = listCardDTOList;
    map['alreadyGetCardDTOList'] = alreadyGetCardDTOList;
    map['listState'] = listState;
    return compute(_convert, map);
  }

  static Future<ListPrefecturesViewData> _convert(
    Map<dynamic, dynamic> parameter,
  ) async {
    final listCardDTOList = parameter['listCardDTOList'] as List<ListCardDTO>;
    final alreadyGetCardDTOList =
        parameter['alreadyGetCardDTOList'] as List<AlreadyGetCardDTO>;
    final listState = parameter['listState'] as ListState;

    final prefectureIdList = listCardDTOList
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
            final cardList = listCardDTOList
                .where((dto) => dto.prefectureId == id)
                .map(
                  (dto) {
                    final alreadyGet = alreadyGetCardDTOList
                        .map((e) => e.cardId)
                        .contains(dto.id);
                    if (listState == ListState.alreadyGet && !alreadyGet) {
                      return null;
                    }
                    return ListCardViewData(
                      id: dto.id,
                      imageUrl:
                          alreadyGet ? dto.colorImageUrl : dto.grayImageUrl,
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

            final prefectureName = listCardDTOList
                .firstWhere((dto) => dto.prefectureId == id)
                .prefectureName;

            return ListPrefectureViewData(
              id: id,
              name: prefectureName.isEmpty ? '全国' : prefectureName,
              cards: ListCardsViewData(
                list: cardList,
              ),
              initiallyExpanded: false,
            );
          },
        )
        .whereType<ListPrefectureViewData>()
        .toList();
    return ListPrefecturesViewData(list: prefectureList);
  }
}
