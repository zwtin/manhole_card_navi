import 'package:flutter_test/flutter_test.dart';

import 'package:app/src/mapper/list_prefectures_view_data_mapper.dart';
import 'package:domain/domain.dart';

ManholeCard _card(String id, {required String prefectureId}) {
  return ManholeCard(
    id: id,
    position: const Coordinate(latitude: 35.68, longitude: 139.76),
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

  test('都道府県は最初に出てきた順に並び、分母は取得済みで絞り込む前の枚数', () {
    final viewData = ListPrefecturesViewDataMapper.toViewData(
      cards: cards,
      alreadyGetCardIds: {'A'},
      searchCondition: const CommonSearchCondition(
        alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
      ),
      expandedPrefectureIds: {'27'},
    );

    expect(
      viewData.list.map(
        (prefecture) => (
          prefecture.id,
          prefecture.alreadyGetCount,
          prefecture.totalCount,
          prefecture.initiallyExpanded,
          prefecture.cards.list.map((card) => card.id).join(','),
        ),
      ),
      [('13', 1, 2, false, 'C'), ('27', 0, 1, true, 'B')],
    );
  });

  test('取得済みで絞り込んで 1 枚も残らない都道府県は出さない', () {
    final viewData = ListPrefecturesViewDataMapper.toViewData(
      cards: cards,
      alreadyGetCardIds: {'B'},
      searchCondition: const CommonSearchCondition(
        alreadyGetFilter: AlreadyGetFilter.alreadyGet,
      ),
      expandedPrefectureIds: const {},
    );

    expect(viewData.list.map((prefecture) => prefecture.id), ['27']);
  });
}
