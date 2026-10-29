import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/detail_card_view_data.dart';
import 'package:app/src/view_model/detail_view_model.dart';
import 'package:domain/domain.dart';

import 'test_doubles.dart';

void main() {
  late MockAlreadyGetCardUseCase alreadyGetCardUseCase;
  late MockCardUseCase cardUseCase;
  late MockNavigationService navigationService;
  late StreamController<Set<String>> alreadyGet;
  late Set<String> alreadyGetIds;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    final analyticsUseCase = MockAnalyticsUseCase();
    alreadyGetCardUseCase = MockAlreadyGetCardUseCase();
    cardUseCase = MockCardUseCase();
    navigationService = MockNavigationService();
    alreadyGet = StreamController.broadcast();
    alreadyGetIds = {};

    when(
      () => alreadyGetCardUseCase.watch(),
    ).thenAnswer((_) => watching(alreadyGetIds, alreadyGet.stream));
    when(
      () => alreadyGetCardUseCase.save(id: any(named: 'id')),
    ).thenAnswer((_) async => const Result.success(null));
    when(
      () => alreadyGetCardUseCase.delete(id: any(named: 'id')),
    ).thenAnswer((_) async => const Result.success(null));
    when(
      () => analyticsUseCase.send(event: any(named: 'event')),
    ).thenAnswer((_) async => const Result.success(null));
    when(
      () => cardUseCase.get(id: 'A'),
    ).thenAnswer((_) async => Result.success(manholeCard(id: 'A')));
    when(
      () => navigationService.showFailure(
        title: any(named: 'title'),
        exception: any(named: 'exception'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => navigationService.presentImageDetail(
        cardId: any(named: 'cardId'),
        alreadyGet: any(named: 'alreadyGet'),
        heroTag: any(named: 'heroTag'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => navigationService.openUrl(any(), external: any(named: 'external')),
    ).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        alreadyGetCardUseCaseProvider.overrideWithValue(alreadyGetCardUseCase),
        analyticsUseCaseProvider.overrideWithValue(analyticsUseCase),
        cardUseCaseProvider.overrideWithValue(cardUseCase),
        navigationServiceProvider.overrideWithValue(navigationService),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await alreadyGet.close();
  });

  /// 詳細を開き、読み込みが終わるまで待つ。
  Future<DetailCardViewData> load() {
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(detailViewModelProvider('A'), (_, __) {});
    return container.read(detailViewModelProvider('A').future);
  }

  Future<DetailViewModel> open() async {
    await load();
    return container.read(detailViewModelProvider('A').notifier);
  }

  test('未取得なら、確かめずに取得済みにする', () async {
    final viewModel = await open();

    await viewModel.onTapAlreadyGetButton();

    verify(() => alreadyGetCardUseCase.save(id: 'A')).called(1);
    verifyNever(
      () => navigationService.showConfirm(
        title: any(named: 'title'),
        message: any(named: 'message'),
      ),
    );
  });

  test('未取得に戻すときは確かめ、やめたら変えない', () async {
    alreadyGetIds = {'A'};
    final viewModel = await open();
    void stubConfirm(bool confirmed) {
      when(
        () => navigationService.showConfirm(
          title: any(named: 'title'),
          message: any(named: 'message'),
        ),
      ).thenAnswer((_) async => confirmed);
    }

    stubConfirm(false);
    await viewModel.onTapAlreadyGetButton();
    verifyNever(() => alreadyGetCardUseCase.delete(id: any(named: 'id')));

    stubConfirm(true);
    await viewModel.onTapAlreadyGetButton();
    verify(() => alreadyGetCardUseCase.delete(id: 'A')).called(1);
  });

  test('取得済みが変わると、画像の拡大にもその状態を渡す', () async {
    final viewModel = await open();

    alreadyGet.add({'A'});
    await pumpEventQueue();
    await viewModel.onTapImage('hero-1');

    verify(
      () => navigationService.presentImageDetail(
        cardId: 'A',
        alreadyGet: true,
        heroTag: 'hero-1',
      ),
    ).called(1);
  });

  test('「マップで見る」で、マップのタブにカードのモーダルを開く', () async {
    final viewModel = await open();

    await viewModel.onTapCheckWithMapButton();

    verify(() => navigationService.showCardOnMap(cardId: 'A')).called(1);
  });

  test('HTML のリンクは、アプリ内ブラウザで開く', () async {
    final viewModel = await open();

    await viewModel.onTapLink('https://example.com');

    verify(() => navigationService.openUrl('https://example.com')).called(1);
  });

  test('カードを取れなければ知らせる', () async {
    when(
      () => cardUseCase.get(id: 'A'),
    ).thenAnswer((_) async => const Result.failure(NotFoundException()));

    await expectLater(load(), throwsA(isA<NotFoundException>()));
    verify(
      () => navigationService.showFailure(
        title: 'カード情報を取得できませんでした',
        exception: any(named: 'exception', that: isA<NotFoundException>()),
      ),
    ).called(1);
  });
}
