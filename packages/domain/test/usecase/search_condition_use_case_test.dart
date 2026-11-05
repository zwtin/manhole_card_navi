import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'package:domain/domain.dart';

class MockCardRepository extends Mock implements CardRepository {}

class MockSearchConditionRepository extends Mock
    implements SearchConditionRepository {}

ManholeCard _card({required String id, required String volumeId}) {
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
    prefecture: const Prefecture(id: '13', name: '東京都'),
    volume: Volume(id: volumeId, name: '弾 $volumeId'),
  );
}

void main() {
  late MockCardRepository cardRepository;
  late MockSearchConditionRepository searchConditionRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(SearchCondition.initial());
  });

  setUp(() {
    cardRepository = MockCardRepository();
    searchConditionRepository = MockSearchConditionRepository();
    container = ProviderContainer(
      overrides: [
        cardRepositoryProvider.overrideWithValue(cardRepository),
        searchConditionRepositoryProvider.overrideWithValue(
          searchConditionRepository,
        ),
      ],
    );
    when(() => cardRepository.fetchAll()).thenAnswer(
      (_) async => Result.success([
        _card(id: 'A', volumeId: '0000'),
        _card(id: 'B', volumeId: '0001'),
        _card(id: 'C', volumeId: '0001'),
        _card(id: 'D', volumeId: ''),
      ]),
    );
    when(
      () => searchConditionRepository.save(
        searchCondition: any(named: 'searchCondition'),
      ),
    ).thenAnswer((_) async => const Result.success(null));
  });

  tearDown(() {
    container.dispose();
  });

  SearchConditionUseCase getUseCase() {
    return container.read(searchConditionUseCaseProvider);
  }

  SearchCondition savedCondition() {
    return verify(
          () => searchConditionRepository.save(
            searchCondition: captureAny(named: 'searchCondition'),
          ),
        ).captured.single
        as SearchCondition;
  }

  group('save', () {
    test('すべての弾を選んだ状態は、未選択（すべて表示）にして保存する', () async {
      // 弾の ID が空のカード D は、全弾に数えない。
      await getUseCase().save(
        searchCondition: SearchCondition(
          common: CommonSearchCondition(volumeIds: {'0000', '0001'}),
        ),
      );

      expect(savedCondition().common.volumeIds, isEmpty);
    });

    test('すべての配布状態を選んだ状態は、未選択にして保存する', () async {
      await getUseCase().save(
        searchCondition: SearchCondition(
          common: CommonSearchCondition(
            distributionStates: DistributionState.values.toSet(),
          ),
        ),
      );

      expect(savedCondition().common.distributionStates, isEmpty);
    });

    test('一部だけ選んだ状態・知らない弾・取得状態・マップの表示はそのまま保存する', () async {
      final condition = SearchCondition(
        common: CommonSearchCondition(
          alreadyGetFilter: AlreadyGetFilter.notAlreadyGet,
          volumeIds: {'0000', '9999'},
          distributionStates: {DistributionState.stopped},
        ),
        map: const MapSearchCondition(
          coordinateType: MapCoordinateType.position,
          pinSize: MapPinSize.large,
        ),
      );

      await getUseCase().save(searchCondition: condition);

      expect(savedCondition(), condition);
    });

    test('全弾は保存する時点のマスターで決める', () async {
      // 編集を始めた後に新弾 0002 が入った。0000・0001 だけでは全弾ではない。
      when(() => cardRepository.fetchAll()).thenAnswer(
        (_) async => Result.success([
          _card(id: 'A', volumeId: '0000'),
          _card(id: 'B', volumeId: '0001'),
          _card(id: 'E', volumeId: '0002'),
        ]),
      );

      await getUseCase().save(
        searchCondition: SearchCondition(
          common: CommonSearchCondition(volumeIds: {'0000', '0001'}),
        ),
      );

      expect(savedCondition().common.volumeIds, {'0000', '0001'});
    });

    test('カードを取れなければ保存せず、その失敗を返す', () async {
      const exception = PersistenceException();
      when(
        () => cardRepository.fetchAll(),
      ).thenAnswer((_) async => const Result.failure(exception));

      final result = await getUseCase().save(
        searchCondition: SearchCondition.initial(),
      );

      expect((result as Failure<void>).exception, exception);
      verifyNever(
        () => searchConditionRepository.save(
          searchCondition: any(named: 'searchCondition'),
        ),
      );
    });

    test('保存できなければ、その失敗を返す', () async {
      const exception = PersistenceException();
      when(
        () => searchConditionRepository.save(
          searchCondition: any(named: 'searchCondition'),
        ),
      ).thenAnswer((_) async => const Result.failure(exception));

      final result = await getUseCase().save(
        searchCondition: SearchCondition.initial(),
      );

      expect((result as Failure<void>).exception, exception);
    });
  });
}
