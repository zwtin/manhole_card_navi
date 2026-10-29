import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/list_prefecture_view_data.dart';
import 'package:app/src/view_data/manhole_card_list_view_data.dart';
import 'package:app/src/view_model/manhole_card_list_view_model.dart';
import 'package:domain/domain.dart';

import 'test_doubles.dart';

void main() {
  late MockCardUseCase cardUseCase;
  late MockNavigationService navigationService;
  late StreamController<Set<String>> alreadyGet;
  late StreamController<SearchCondition> searchCondition;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    final alreadyGetCardUseCase = MockAlreadyGetCardUseCase();
    final analyticsUseCase = MockAnalyticsUseCase();
    final searchConditionUseCase = MockSearchConditionUseCase();
    cardUseCase = MockCardUseCase();
    navigationService = MockNavigationService();
    alreadyGet = StreamController.broadcast();
    searchCondition = StreamController.broadcast();

    when(
      () => alreadyGetCardUseCase.watch(),
    ).thenAnswer((_) => watching({'A'}, alreadyGet.stream));
    when(
      () => analyticsUseCase.send(event: any(named: 'event')),
    ).thenAnswer((_) async => const Result.success(null));
    when(() => searchConditionUseCase.watch()).thenAnswer(
      (_) => watching(SearchCondition.initial(), searchCondition.stream),
    );
    when(() => cardUseCase.fetchAll()).thenAnswer(
      (_) async => Result.success([
        manholeCard(id: 'A', prefectureId: '13'),
        manholeCard(id: 'B', prefectureId: '27'),
        manholeCard(id: 'C', prefectureId: '13'),
      ]),
    );
    when(
      () => navigationService.showFailure(
        title: any(named: 'title'),
        exception: any(named: 'exception'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => navigationService.pushCardDetail(cardId: any(named: 'cardId')),
    ).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        alreadyGetCardUseCaseProvider.overrideWithValue(alreadyGetCardUseCase),
        analyticsUseCaseProvider.overrideWithValue(analyticsUseCase),
        cardUseCaseProvider.overrideWithValue(cardUseCase),
        navigationServiceProvider.overrideWithValue(navigationService),
        searchConditionUseCaseProvider.overrideWithValue(
          searchConditionUseCase,
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await Future.wait([alreadyGet.close(), searchCondition.close()]);
  });

  /// 一覧を開き、読み込みが終わるまで待つ。
  Future<ManholeCardListViewData> load() {
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(manholeCardListViewModelProvider, (_, __) {});
    return container.read(manholeCardListViewModelProvider.future);
  }

  ManholeCardListViewData state() {
    return container.read(manholeCardListViewModelProvider).requireValue;
  }

  ListPrefectureViewData prefecture(String id) {
    return state().prefectures.singleWhere((prefecture) => prefecture.id == id);
  }

  test('見出しには、取得済みの枚数と全体の枚数を出す', () async {
    await load();

    expect(state().navigationTitle, 'リスト　1/3');
  });

  test('取得済みが変わっても、開いた都道府県は開いたまま', () async {
    await load();
    container
        .read(manholeCardListViewModelProvider.notifier)
        .onExpandedChanged(true, '27');

    alreadyGet.add({'A', 'B'});
    await pumpEventQueue();

    expect(prefecture('27').initiallyExpanded, isTrue);
    expect(prefecture('27').alreadyGetCount, 1);
    expect(prefecture('13').initiallyExpanded, isFalse);
  });

  test('検索条件が変わると、絞り込んで作り直す', () async {
    await load();

    searchCondition.add(
      const SearchCondition(
        common: CommonSearchCondition(
          alreadyGetFilter: AlreadyGetFilter.alreadyGet,
        ),
      ),
    );
    await pumpEventQueue();

    expect(state().prefectures.map((prefecture) => prefecture.id), ['13']);
    expect(prefecture('13').cards.map((card) => card.id), ['A']);
    expect(state().activeFilterCount, 1);
  });

  test('カードを取れなければ知らせ、空の一覧で続ける', () async {
    when(
      () => cardUseCase.fetchAll(),
    ).thenAnswer((_) async => const Result.failure(NotFoundException()));

    await load();

    expect(state().prefectures, isEmpty);
    expect(state().totalCount, 0);
    verify(
      () => navigationService.showFailure(
        title: 'カード一覧を取得できませんでした',
        exception: any(named: 'exception', that: isA<NotFoundException>()),
      ),
    ).called(1);
  });

  test('カードを押すと、詳細を開く', () async {
    await load();

    await container.read(manholeCardListViewModelProvider.notifier).onTap('C');

    verify(() => navigationService.pushCardDetail(cardId: 'C')).called(1);
  });
}
