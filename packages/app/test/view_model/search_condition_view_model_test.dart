import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/src/mapper/search_condition_view_data_mapper.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_model/search_condition_view_model.dart';
import 'package:domain/domain.dart';

import 'test_doubles.dart';

ManholeCard _card({required String volumeId, required String volumeName}) {
  return ManholeCard(
    id: 'card-$volumeId',
    position: Coordinate(latitude: 34.69, longitude: 135.50),
    name: 'カード',
    publicationDate: DateTime(2026, 1, 1),
    distributionState: DistributionState.distributing,
    distributionPlaceHtml: '',
    distributionTimeHtml: '',
    stockHtml: '',
    distributionPoints: const [],
    prefecture: const Prefecture(id: '27', name: '大阪府'),
    volume: Volume(id: volumeId, name: volumeName),
  );
}

void main() {
  late MockCardBrowsingSettingsUseCase settingsUseCase;
  late MockNavigationService navigationService;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() async {
    final cardUseCase = MockCardUseCase();
    settingsUseCase = MockCardBrowsingSettingsUseCase();
    navigationService = MockNavigationService();

    when(
      () => settingsUseCase.watch(),
    ).thenAnswer((_) => Stream.value(CardBrowsingSettings.initial()));
    when(() => cardUseCase.fetchAll()).thenAnswer(
      (_) async => Result.success([
        _card(volumeId: '0000', volumeName: '第1弾'),
        _card(volumeId: '0017', volumeName: '第18弾'),
        _card(volumeId: '0001', volumeName: '第2弾'),
      ]),
    );
    when(
      () => settingsUseCase.save(settings: any(named: 'settings')),
    ).thenAnswer((_) async => const Result.success(null));

    container = ProviderContainer(
      overrides: [
        analyticsUseCaseProvider.overrideWithValue(MockAnalyticsUseCase()),
        cardUseCaseProvider.overrideWithValue(cardUseCase),
        navigationServiceProvider.overrideWithValue(navigationService),
        cardBrowsingSettingsUseCaseProvider.overrideWithValue(settingsUseCase),
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

  CardBrowsingSettings savedSettings() {
    return verify(
          () => settingsUseCase.save(settings: captureAny(named: 'settings')),
        ).captured.single
        as CardBrowsingSettings;
  }

  test('弾の選択肢は新しい弾から並ぶ', () {
    final state = container.read(searchConditionViewModelProvider).requireValue;

    expect(state.volumes.map((option) => option.label), ['第18弾', '第2弾', '第1弾']);
  });

  test('弾を切り替えるとドラフトだけが変わり、保存はしない', () {
    viewModel().toggleVolume(1);

    final state = container.read(searchConditionViewModelProvider).requireValue;
    expect(state.volumes[1], (label: '第2弾', selected: true));
    verifyNever(() => settingsUseCase.save(settings: any(named: 'settings')));
  });

  test('一部の弾を選んで適用すると、その条件を保存して閉じる', () async {
    viewModel()
      ..toggleVolume(1)
      ..selectAlreadyGetFilter(
        SearchConditionViewDataMapper.alreadyGetFilters.indexOf(
          AlreadyGetFilter.alreadyGet,
        ),
      );

    await viewModel().onApply();

    final saved = savedSettings();
    expect(saved.searchCondition.volumeIds, {'0001'});
    expect(saved.searchCondition.alreadyGetFilter, AlreadyGetFilter.alreadyGet);
    verify(() => navigationService.pop()).called(1);
  });

  test('すべての弾を選んで適用すると、選んだままの条件を保存に渡す', () async {
    // 全選択を未選択にそろえるのは、保存する UseCase の役目。
    viewModel().selectAllVolumes();

    await viewModel().onApply();

    expect(savedSettings().searchCondition.volumeIds, {'0000', '0001', '0017'});
  });

  test('保存できなければ知らせ、閉じずに編集中の条件を残す', () async {
    when(
      () => settingsUseCase.save(settings: any(named: 'settings')),
    ).thenAnswer((_) async => const Result.failure(PersistenceException()));
    when(
      () => navigationService.showFailure(
        title: any(named: 'title'),
        exception: any(named: 'exception'),
      ),
    ).thenAnswer((_) async {});
    viewModel().toggleVolume(0);

    await viewModel().onApply();

    verify(
      () => navigationService.showFailure(
        title: '検索条件を保存できませんでした',
        exception: any(named: 'exception', that: isA<PersistenceException>()),
      ),
    ).called(1);
    verifyNever(() => navigationService.pop());
    final state = container.read(searchConditionViewModelProvider).requireValue;
    expect(state.volumes.first.selected, isTrue);
  });

  test('適用すると、検索条件とマップの表示を 1 回でまとめて保存する', () async {
    viewModel()
      ..toggleVolume(1)
      ..selectCoordinateType(
        SearchConditionViewDataMapper.coordinateTypes.indexOf(
          MapCoordinateType.position,
        ),
      );

    await viewModel().onApply();

    // savedSettings は 1 回だけ呼ばれたことも確かめる。
    final saved = savedSettings();
    expect(saved.searchCondition.volumeIds, {'0001'});
    expect(saved.mapDisplaySettings.coordinateType, MapCoordinateType.position);
  });

  test('ピンの大きさは既定で中。選び直して適用すると保存する', () async {
    final state = container.read(searchConditionViewModelProvider).requireValue;
    expect(state.pinSizes.singleWhere((option) => option.selected).label, '中');

    viewModel().selectPinSize(
      SearchConditionViewDataMapper.pinSizes.indexOf(MapPinSize.smallest),
    );
    await viewModel().onApply();

    expect(savedSettings().mapDisplaySettings.pinSize, MapPinSize.smallest);
  });

  test('リセットは絞り込みだけを消し、マップ表示は残す', () async {
    viewModel()
      ..selectCoordinateType(
        SearchConditionViewDataMapper.coordinateTypes.indexOf(
          MapCoordinateType.position,
        ),
      )
      ..selectPinSize(
        SearchConditionViewDataMapper.pinSizes.indexOf(MapPinSize.largest),
      )
      ..toggleDistributionState(
        SearchConditionViewDataMapper.distributionStates.indexOf(
          DistributionState.stopped,
        ),
      )
      ..clearAllFilters();

    await viewModel().onApply();

    final saved = savedSettings();
    expect(saved.searchCondition.activeFilterCount, 0);
    expect(saved.mapDisplaySettings.coordinateType, MapCoordinateType.position);
    expect(saved.mapDisplaySettings.pinSize, MapPinSize.largest);
  });

  test('閉じるときは保存しない', () {
    viewModel().onClose();

    verify(() => navigationService.pop()).called(1);
    verifyNever(() => settingsUseCase.save(settings: any(named: 'settings')));
  });
}
