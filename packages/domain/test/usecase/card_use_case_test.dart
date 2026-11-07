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
    position: Coordinate(latitude: 35.68, longitude: 139.76),
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
    SearchCondition searchCondition, {
    Set<String> alreadyGetCardIds = const {},
  }) {
    return useCase
        .filter(
          searchCondition: searchCondition,
          cards: cards,
          alreadyGetCardIds: alreadyGetCardIds,
        )
        .map((card) => card.id)
        .toList();
  }

  group('filter', () {
    test('絞り込みがなければ、すべてのカードを順序どおり返す', () {
      expect(filteredIds(const SearchCondition()), ['A', 'B', 'C', 'D']);
    });

    test('弾は、選んだどれかに当たるカードを通す', () {
      expect(filteredIds(SearchCondition(volumeIds: {'0001', '0002'})), [
        'B',
        'C',
        'D',
      ]);
    });

    test('配布状態は、選んだどれかに当たるカードを通す', () {
      expect(
        filteredIds(
          SearchCondition(
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
          const SearchCondition(alreadyGetFilter: AlreadyGetFilter.alreadyGet),
          alreadyGetCardIds: {'A', 'C'},
        ),
        ['A', 'C'],
      );
      expect(
        filteredIds(
          const SearchCondition(
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
          SearchCondition(
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
      expect(filteredIds(SearchCondition(volumeIds: {'9999'})), isEmpty);
    });

    test('渡したリストを変えず、Repository も呼ばない', () {
      final input = List.of(cards);

      final result = useCase.filter(
        searchCondition: SearchCondition(volumeIds: {'0000'}),
        cards: input,
        alreadyGetCardIds: const {},
      );

      expect(input, cards);
      expect(identical(result, input), isFalse);
      verifyZeroInteractions(cardRepository);
    });
  });
}
