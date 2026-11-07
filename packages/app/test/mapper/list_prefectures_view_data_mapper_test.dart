import 'package:flutter_test/flutter_test.dart';

import 'package:app/src/mapper/list_prefectures_view_data_mapper.dart';
import 'package:domain/domain.dart';

ManholeCard _card(String id, {required String prefectureId}) {
  return ManholeCard(
    id: id,
    position: Coordinate(latitude: 35.68, longitude: 139.76),
    name: 'カード $id',
    publicationDate: DateTime(2026, 1, 2),
    distributionState: DistributionState.distributing,
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: const [],
    prefecture: Prefecture(id: prefectureId, name: '県 $prefectureId'),
    volume: const Volume(id: '0000', name: '第1弾'),
  );
}

void main() {
  final cards = [
    _card('A', prefectureId: '13'),
    _card('B', prefectureId: '27'),
    _card('C', prefectureId: '13'),
  ];

  test('都道府県の並びと分数は集計するカードから、行は表示するカードから作る', () {
    // C は取得済みで絞り込んだので出さないが、13 の分母には数える。
    final viewData = ListPrefecturesViewDataMapper.toViewData(
      countCards: cards,
      visibleCards: [cards[1], cards[2]],
      alreadyGetCardIds: {'A'},
      expandedPrefectureIds: {'27'},
    );

    expect(
      viewData.map(
        (prefecture) => (
          prefecture.id,
          prefecture.alreadyGetCount,
          prefecture.totalCount,
          prefecture.initiallyExpanded,
          prefecture.cards.map((card) => card.id).join(','),
        ),
      ),
      [('13', 1, 2, false, 'C'), ('27', 0, 1, true, 'B')],
    );
  });

  test('表示するカードが 1 枚もない都道府県は出さない', () {
    final viewData = ListPrefecturesViewDataMapper.toViewData(
      countCards: cards,
      visibleCards: [cards[1]],
      alreadyGetCardIds: {'B'},
      expandedPrefectureIds: const {},
    );

    expect(viewData.map((prefecture) => prefecture.id), ['27']);
  });

  test('都道府県の並びは、表示するカードの順ではなく集計するカードの順', () {
    final viewData = ListPrefecturesViewDataMapper.toViewData(
      countCards: cards,
      visibleCards: [cards[1], cards[0]],
      alreadyGetCardIds: const {},
      expandedPrefectureIds: const {},
    );

    expect(viewData.map((prefecture) => prefecture.id), ['13', '27']);
  });
}
