import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:manhole_card_navi/app/provider/alert_provider.dart';
import 'package:manhole_card_navi/app/view_data/list_cards_view_data.dart';
import 'package:manhole_card_navi/app/view_data/list_prefecture_view_data.dart';
import 'package:manhole_card_navi/domain/entity/result.dart';
import 'package:manhole_card_navi/infra/query_service_impl/list_cards_query_service_impl.dart';
import 'package:manhole_card_navi/use_case/dto/list_prefecture_dto.dart';
import 'package:manhole_card_navi/use_case/query_service/list_cards_query_service.dart';

import '/app/view_data/list_card_view_data.dart';
import '/app/view_data/list_prefectures_view_data.dart';

final manholeCardListViewModelProvider =
    ChangeNotifierProvider.family.autoDispose<ManholeCardListViewModel, Key?>(
  (ref, key) {
    return ManholeCardListViewModel(
      key,
      ref,
      ref.watch(listCardsQueryServiceProvider),
    );
  },
);

class ManholeCardListViewModel extends ChangeNotifier {
  ManholeCardListViewModel(
    this._key,
    this._ref,
    this._listCardsQueryService,
  );

  final Key? _key;
  final Ref _ref;
  final _logger = Logger();

  final ListCardsQueryService _listCardsQueryService;

  ListPrefecturesViewData prefecturesViewData =
      const ListPrefecturesViewData(list: []);

  Future<void> onLoad() async {
    _logger.d('ManholeCardListViewModel');
    fetchCards();
  }

  Future<void> fetchCards() async {
    final result = await _listCardsQueryService.fetch();
    if (result is Failure) {
      _ref.read(alertProvider.notifier).show(
            title: 'エラー',
            message: 'カード情報の取得に失敗しました',
            okButtonTitle: 'OK',
            okButtonAction: () async {},
            cancelButtonTitle: null,
            cancelButtonAction: null,
          );
      return;
    }
    final dtoList = (result as Success<List<ListPrefectureDTO>>).value;
    final prefectureList = await Future.wait(
      dtoList.map(
        (prefectureDTO) async {
          final cardList = await Future.wait(
            prefectureDTO.cards.map(
              (cardDTO) async {
                final cardImageOrNull =
                    await img.decodeJpgFile(cardDTO.imagePath);
                final cardImage = cardImageOrNull!;
                final cardThumbnail =
                    img.copyResize(cardImage, width: 130, height: 180);

                return ListCardViewData(
                  id: cardDTO.id,
                  icon: img.encodePng(cardThumbnail).buffer.asUint8List(),
                );
              },
            ),
          );
          return ListPrefectureViewData(
            id: prefectureDTO.id,
            name: prefectureDTO.name.isEmpty ? '全国' : prefectureDTO.name,
            cards: ListCardsViewData(
              list: cardList,
            ),
          );
        },
      ),
    );
    prefecturesViewData = ListPrefecturesViewData(list: prefectureList);
    notifyListeners();
  }

  Future<void> onTap(String cardId) async {
    _logger.d('ManholeCardListViewModel');
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('ManholeCardListViewModel dispose');
  }
}
