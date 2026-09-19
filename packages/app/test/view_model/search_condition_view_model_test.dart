import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_model/search_condition_view_model.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsUseCase extends Mock implements AnalyticsUseCase {}

class MockCardUseCase extends Mock implements CardUseCase {}

class MockNavigationService extends Mock implements NavigationService {}

class MockSearchConditionUseCase extends Mock
    implements SearchConditionUseCase {}

ManholeCard _card({required String volumeId, required String volumeName}) {
  return ManholeCard(
    id: 'card-$volumeId',
    position: const Coordinate(latitude: 34.69, longitude: 135.50),
    name: 'カード',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: DistributionState.distributing,
    image: '',
    imageSub: '',
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: const [],
    prefecture: const Prefecture(id: '27', name: '大阪府'),
    volume: Volume(id: volumeId, name: volumeName),
  );
}

void main() {
  late MockSearchConditionUseCase searchConditionUseCase;
  late MockNavigationService navigationService;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(SearchCondition.initial());
  });

  setUp(() async {
    final cardUseCase = MockCardUseCase();
    searchConditionUseCase = MockSearchConditionUseCase();
    navigationService = MockNavigationService();

    when(() => searchConditionUseCase.watch()).thenAnswer(
      (_) => Stream.value(SearchCondition.initial()),
    );
    when(() => cardUseCase.fetchAll()).thenAnswer(
      (_) async => Result.success([
        _card(volumeId: '0000', volumeName: '第1弾'),
        _card(volumeId: '0017', volumeName: '第18弾'),
        _card(volumeId: '0001', volumeName: '第2弾'),
      ]),
    );
    when(
      () => searchConditionUseCase.save(
        searchCondition: any(named: 'searchCondition'),
      ),
    ).thenAnswer((_) async => const Result.success(null));

    container = ProviderContainer(
      overrides: [
        analyticsUseCaseProvider.overrideWithValue(MockAnalyticsUseCase()),
        cardUseCaseProvider.overrideWithValue(cardUseCase),
        navigationServiceProvider.overrideWithValue(navigationService),
        searchConditionUseCaseProvider.overrideWithValue(
          searchConditionUseCase,
        ),
      ],
    );
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(searchConditionViewModelProvider, (_, __) {});
    await container.read(searchConditionViewModelProvider.future);
  });

  tearDown(() {
    container.dispose();
  });

  SearchConditionViewModel viewModel() {
    return container.read(searchConditionViewModelProvider.notifier);
  }

  SearchCondition savedCondition() {
    return verify(
      () => searchConditionUseCase.save(
        searchCondition: captureAny(named: 'searchCondition'),
      ),
    ).captured.single as SearchCondition;
  }

  test('弾の選択肢は新しい弾から並ぶ', () {
    final state = container.read(searchConditionViewModelProvider).requireValue;

    expect(
      state.volumeOptions.map((option) => option.id),
      ['0017', '0001', '0000'],
    );
  });

  test('弾を切り替えるとドラフトだけが変わり、保存はしない', () {
    viewModel().toggleVolume('0001');

    final state = container.read(searchConditionViewModelProvider).requireValue;
    expect(state.isVolumeSelected('0001'), isTrue);
    verifyNever(
      () => searchConditionUseCase.save(
        searchCondition: any(named: 'searchCondition'),
      ),
    );
  });

  test('一部の弾を選んで適用すると、その条件を保存して閉じる', () async {
    viewModel()
      ..toggleVolume('0001')
      ..setAlreadyGetFilter(AlreadyGetFilter.alreadyGet);

    await viewModel().onApply();

    final saved = savedCondition();
    expect(saved.common.volumeIds, {'0001'});
    expect(saved.common.alreadyGetFilter, AlreadyGetFilter.alreadyGet);
    verify(() => navigationService.pop()).called(1);
  });

  test('すべての弾を選んで適用すると、未選択（すべて表示）として保存する', () async {
    viewModel().selectAllVolumes();

    await viewModel().onApply();

    expect(savedCondition().common.volumeIds, isEmpty);
  });

  test('リセットは絞り込みだけを消し、マップ表示は残す', () {
    viewModel()
      ..setCoordinateType(MapCoordinateType.position)
      ..toggleDistributionState(DistributionState.stopped)
      ..clearAllFilters();

    final state = container.read(searchConditionViewModelProvider).requireValue;
    expect(state.draft.activeFilterCount, 0);
    expect(state.coordinateType, MapCoordinateType.position);
  });

  test('閉じるときは保存しない', () {
    viewModel().onClose();

    verify(() => navigationService.pop()).called(1);
    verifyNever(
      () => searchConditionUseCase.save(
        searchCondition: any(named: 'searchCondition'),
      ),
    );
  });
}
