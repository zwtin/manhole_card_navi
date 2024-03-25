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
    required List<AlreadyGetCardDTO> originalGetCardDTOList,
    required ListPrefecturesViewData originalViewData,
  }) async {
    final map = <String, dynamic>{};
    map['listCardDTOList'] = listCardDTOList;
    map['getCardDTOList'] = getCardDTOList;
    map['listState'] = listState;
    map['originalGetCardDTOList'] = originalGetCardDTOList;
    map['originalViewData'] = originalViewData;
    return compute(_convert, map);
  }

  static Future<ListPrefecturesViewData> _convert(
    Map<dynamic, dynamic> parameter,
  ) async {
    final listCardDTOList = parameter['listCardDTOList'] as List<ListCardDTO>;
    final getCardDTOList =
        parameter['getCardDTOList'] as List<AlreadyGetCardDTO>;
    final listState = parameter['listState'] as ListState;
    final originalGetCardDTOList =
        parameter['originalGetCardDTOList'] as List<AlreadyGetCardDTO>;
    final originalViewData =
        parameter['originalViewData'] as ListPrefecturesViewData;

    final prefectureIdList = listCardDTOList
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
            listCardDTOList.where((dto) => dto.prefectureId == id).map(
              (dto) async {
                if (getCardDTOList.map((e) => e.cardId).contains(dto.id) &&
                    originalGetCardDTOList
                        .map((e) => e.cardId)
                        .contains(dto.id) &&
                    originalViewData.getById(id)?.cards.getById(dto.id) !=
                        null) {
                  final original =
                      originalViewData.getById(id)!.cards.getById(dto.id)!;

                  bool isHidden = false;
                  if (listState == ListState.alreadyGet) {
                    isHidden =
                        !getCardDTOList.map((e) => e.cardId).contains(dto.id);
                  }

                  return ListCardViewData(
                    id: dto.id,
                    icon: original.icon,
                    name: dto.name,
                    volume: dto.volumeName,
                    publicationDate: dateFormatter.format(dto.publicationDate),
                    isHidden: isHidden,
                  );
                }
                if (!getCardDTOList.map((e) => e.cardId).contains(dto.id) &&
                    !originalGetCardDTOList
                        .map((e) => e.cardId)
                        .contains(dto.id) &&
                    originalViewData.getById(id)?.cards.getById(dto.id) !=
                        null) {
                  final original =
                      originalViewData.getById(id)!.cards.getById(dto.id)!;

                  bool isHidden = false;
                  if (listState == ListState.alreadyGet) {
                    isHidden =
                        !getCardDTOList.map((e) => e.cardId).contains(dto.id);
                  }

                  return ListCardViewData(
                    id: dto.id,
                    icon: original.icon,
                    name: dto.name,
                    volume: dto.volumeName,
                    publicationDate: dateFormatter.format(dto.publicationDate),
                    isHidden: isHidden,
                  );
                }

                final cardImageOrNull = await img.decodeJpgFile(dto.imagePath);
                final cardImage =
                    img.copyResize(cardImageOrNull!, width: 130, height: 180);
                img.Image cardThumbnail;
                if (getCardDTOList.map((e) => e.cardId).contains(dto.id)) {
                  cardThumbnail = cardImage;
                } else {
                  cardThumbnail = img.grayscale(cardImage);
                }

                bool isHidden = false;
                if (listState == ListState.alreadyGet) {
                  isHidden =
                      !getCardDTOList.map((e) => e.cardId).contains(dto.id);
                }

                return ListCardViewData(
                  id: dto.id,
                  icon: img.encodePng(cardThumbnail).buffer.asUint8List(),
                  name: dto.name,
                  volume: dto.volumeName,
                  publicationDate: dateFormatter.format(dto.publicationDate),
                  isHidden: isHidden,
                );
              },
            ),
          );

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
      ),
    );
    return ListPrefecturesViewData(list: prefectureList);
  }
}
