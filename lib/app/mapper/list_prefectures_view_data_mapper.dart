import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
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
    required List<AlreadyGetCardDTO> getCardDTOList,
    required ListState listState,
  }) async {
    final map = {};
    map['listCardDTOList'] = listCardDTOList;
    map['getCardDTOList'] = getCardDTOList;
    map['listState'] = listState;
    return compute(_convert, map);
  }

  static Future<ListPrefecturesViewData> _convert(
    Map<dynamic, dynamic> parameter,
  ) async {
    final listCardDTOList = parameter['listCardDTOList'] as List<ListCardDTO>;
    final getCardDTOList =
        parameter['getCardDTOList'] as List<AlreadyGetCardDTO>;
    final listState = parameter['listState'] as ListState;
    final List<ListCardDTO> fixedCardDTOList = listState == ListState.all
        ? listCardDTOList
        : listCardDTOList.where(
            (element) {
              return getCardDTOList.map((e) => e.cardId).contains(element.id);
            },
          ).toList();
    final prefectureIdList = fixedCardDTOList
        .map(
          (listCardDTO) {
            return listCardDTO.prefectureId;
          },
        )
        .toSet()
        .toList();
    final dateFormatter = DateFormat('yyyy/MM/dd');

    final prefectureList = await Future.wait(
      prefectureIdList.map(
        (id) async {
          final cardList = await Future.wait(
            fixedCardDTOList.where((dto) => dto.prefectureId == id).map(
              (dto) async {
                final cardImageOrNull = await img.decodeJpgFile(dto.imagePath);
                final cardImage = cardImageOrNull!;
                img.Image cardThumbnail;
                if (getCardDTOList.map((e) => e.cardId).contains(dto.id)) {
                  cardThumbnail = cardImage;
                } else {
                  cardThumbnail = img.grayscale(cardImage);
                }
                return ListCardViewData(
                  id: dto.id,
                  icon: img.encodePng(cardThumbnail).buffer.asUint8List(),
                  name: dto.name,
                  volume: dto.volumeName,
                  publicationDate: dateFormatter.format(dto.publicationDate),
                );
              },
            ),
          );

          final prefectureName = fixedCardDTOList
              .firstWhere((dto) => dto.prefectureId == id)
              .prefectureName;

          return ListPrefectureViewData(
            id: id,
            name: prefectureName.isEmpty ? '全国' : prefectureName,
            cards: ListCardsViewData(
              list: cardList,
            ),
          );
        },
      ),
    );
    return ListPrefecturesViewData(list: prefectureList);
  }
}
