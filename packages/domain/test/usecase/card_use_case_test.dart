import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:domain/domain.dart';

class MockCardRepository extends Mock implements CardRepository {}

ManholeCard _card({
  required String id,
  String volumeId = '0000',
  DistributionState distributionState = DistributionState.distributing,
}) {
  return ManholeCard(
    id: id,
    position: const Coordinate(latitude: 35.68, longitude: 139.76),
    name: 'カード $id',
    publicationDate: DateTime(2026, 1, 2),
    distributionState: distributionState,
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: const [],
    prefecture: const Prefecture(id: '13', name: '東京都'),
    volume: Volume(id: volumeId, name: '弾 $volumeId'),
  );
}

void main() {
  late MockCardRepository cardRepository;
  late CardUseCase useCase;

  final cards = [
    _card(id: 'A'),
    _card(
      id: 'B',
      volumeId: '0001',
      distributionState: DistributionState.stopped,
    ),
    _card(id: 'C', volumeId: '0001'),
    _card(
      id: 'D',
      volumeId: '0002',
      distributionState: DistributionState.notClear,
    ),
  ];

  setUp(() {
    cardRepository = MockCardRepository();
    useCase = CardUseCase(cardRepository);
  });

  List<String> filteredIds(
    CommonSearchCondition common, {
    Set<String> alreadyGetCardIds = const {},
  }) {
    return useCase
        .filter(
          searchCondition: SearchCondition(common: common),
          cards: cards,
          alreadyGetCardIds: alreadyGetCardIds,
        )
        .map((card) => card.id)
        .toList();
  }

  group('filter', () {
    test('絞り込みがなければ、すべてのカードを順序どおり返す', () {
      expect(filteredIds(const CommonSearchCondition()), ['A', 'B', 'C', 'D']);
    });

    test('弾は、選んだどれかに当たるカードを通す', () {
      expect(filteredIds(CommonSearchCondition(volumeIds: {'0001', '0002'})), [
        'B',
        'C',
        'D',
      ]);
    });

    test('配布状態は、選んだどれかに当たるカードを通す', () {
      expect(
        filteredIds(
          CommonSearchCondition(
            distributionStates: {
              DistributionState.stopped,
              DistributionState.notClear,
            },
          ),
        ),
        ['B', 'D'],
      );
    });

    test('取得状態で絞り込む', () {
      expect(
        filteredIds(
          const CommonSearchCondition(
            alreadyGetFilter: AlreadyGetFilter.alreadyGet,
          ),
          alreadyGetCardIds: {'A', 'C'},
        ),
        ['A', 'C'],
      );
      expect(
        filteredIds(
          const CommonSearchCondition(
            alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
          ),
          alreadyGetCardIds: {'A', 'C'},
        ),
        ['B', 'D'],
      );
    });

    test('弾・配布状態・取得状態は、すべてに当たるカードだけを通す', () {
      expect(
        filteredIds(
          CommonSearchCondition(
            alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
            volumeIds: {'0001'},
            distributionStates: {DistributionState.distributing},
          ),
          alreadyGetCardIds: {'B'},
        ),
        ['C'],
      );
    });

    test('当たるカードがなければ空', () {
      expect(filteredIds(CommonSearchCondition(volumeIds: {'9999'})), isEmpty);
    });

    test('マップの表示の設定では絞り込まない', () {
      final result = useCase.filter(
        searchCondition: const SearchCondition(
          map: MapSearchCondition(
            coordinateType: MapCoordinateType.position,
            pinSize: MapPinSize.smallest,
          ),
        ),
        cards: cards,
        alreadyGetCardIds: const {},
      );

      expect(result, cards);
    });

    test('渡したリストを変えず、Repository も呼ばない', () {
      final input = List.of(cards);

      final result = useCase.filter(
        searchCondition: SearchCondition(
          common: CommonSearchCondition(volumeIds: {'0000'}),
        ),
        cards: input,
        alreadyGetCardIds: const {},
      );

      expect(input, cards);
      expect(identical(result, input), isFalse);
      verifyZeroInteractions(cardRepository);
    });
  });
}
