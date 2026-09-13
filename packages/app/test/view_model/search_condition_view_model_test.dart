import 'package:app/src/view_model/search_condition_view_model.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsUseCase extends Mock implements AnalyticsUseCase {}

class MockListCardsQueryService extends Mock implements ListCardsQueryService {}

class MockNavigationService extends Mock implements NavigationService {}

class MockSearchConditionQueryService extends Mock
    implements SearchConditionQueryService {}

class MockSearchConditionUseCase extends Mock
    implements SearchConditionUseCase {}

ListCardDTO _card({required String volumeId, required String volumeName}) {
  return ListCardDTO(
    id: 'card-$volumeId',
    name: 'カード',
    imagePath: '',
    imageSubPath: '',
    prefectureId: '27',
    prefectureName: '大阪府',
    volumeId: volumeId,
    volumeName: volumeName,
    distributionState: 'distributing',
    publicationDate: DateTime(2026, 1, 1),
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
    final searchConditionQueryService = MockSearchConditionQueryService();
    final listCardsQueryService = MockListCardsQueryService();
    searchConditionUseCase = MockSearchConditionUseCase();
    navigationService = MockNavigationService();

    when(() => searchConditionQueryService.get()).thenAnswer(
      (_) async => Result.success(SearchCondition.initial()),
    );
    when(() => listCardsQueryService.fetch()).thenAnswer(
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
        listCardsQueryServiceProvider.overrideWithValue(listCardsQueryService),
        navigationServiceProvider.overrideWithValue(navigationService),
        searchConditionQueryServiceProvider.overrideWithValue(
          searchConditionQueryService,
        ),
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
      ..setDisplayFilter(DisplayFilter.acquired);

    await viewModel().onApply();

    final saved = savedCondition();
    expect(saved.common.volumeIds, {'0001'});
    expect(saved.common.displayFilter, DisplayFilter.acquired);
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
      ..toggleDistributionState(const ManholeCardDistributionState.stopped())
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
