import 'package:image/image.dart' as img;
import 'package:manhole_card_navi/app/view_data/list_card_view_data.dart';
import 'package:manhole_card_navi/app/view_data/list_cards_view_data.dart';
import 'package:manhole_card_navi/app/view_data/list_prefecture_view_data.dart';

import '/app/view_data/list_prefectures_view_data.dart';
import '/use_case/dto/already_get_card_dto.dart';
import '/use_case/dto/list_card_dto.dart';

class ListPrefecturesViewDataMapper {
  static Future<ListPrefecturesViewData> convertToViewData({
    required List<ListCardDTO> listCardDTOList,
    required List<AlreadyGetCardDTO> getCardDTOList,
  }) async {
    final prefectureIdList = listCardDTOList
        .map(
          (listCardDTO) {
            return listCardDTO.prefectureId;
          },
        )
        .toSet()
        .toList();
    final prefectureList = await Future.wait(
      prefectureIdList.map(
        (id) async {
          final cardList = await Future.wait(
            listCardDTOList.where((dto) => dto.prefectureId == id).map(
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
                );
              },
            ),
          );
          return ListPrefectureViewData(
            id: id,
            name: listCardDTOList
                .firstWhere((dto) => dto.prefectureId == id)
                .prefectureName,
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
