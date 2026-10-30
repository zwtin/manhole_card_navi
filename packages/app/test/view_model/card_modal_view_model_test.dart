import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/src/router/app_router.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/card_modal_view_data.dart';
import 'package:app/src/view_model/card_modal_view_model.dart';
import 'package:domain/domain.dart';

import 'test_doubles.dart';

void main() {
  late MockAlreadyGetCardUseCase alreadyGetCardUseCase;
  late MockNavigationService navigationService;
  late StreamController<Set<String>> alreadyGet;
  late Set<String> alreadyGetIds;
  late MapCoordinateType coordinateType;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    final analyticsUseCase = MockAnalyticsUseCase();
    final cardUseCase = MockCardUseCase();
    final searchConditionUseCase = MockSearchConditionUseCase();
    alreadyGetCardUseCase = MockAlreadyGetCardUseCase();
    navigationService = MockNavigationService();
    alreadyGet = StreamController.broadcast();
    alreadyGetIds = {};
    coordinateType = MapCoordinateType.distribution;

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
    when(() => cardUseCase.get(id: 'B')).thenAnswer(
      (_) async =>
          Result.success(manholeCard(id: 'B', distributionPoints: const [])),
    );
    when(() => searchConditionUseCase.watch()).thenAnswer(
      (_) => watching(
        SearchCondition(
          map: MapSearchCondition(coordinateType: coordinateType),
        ),
        const Stream.empty(),
      ),
    );
    when(
      () => navigationService.openUrl(any(), external: any(named: 'external')),
    ).thenAnswer((_) async {});
    when(
      () => navigationService.showChoice(options: any(named: 'options')),
    ).thenAnswer((_) async => null);
    when(
      () => navigationService.showFailure(
        title: any(named: 'title'),
        exception: any(named: 'exception'),
      ),
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
    debugDefaultTargetPlatformOverride = null;
    container.dispose();
    await alreadyGet.close();
  });

  /// モーダルを開き、読み込みが終わるまで待つ。
  Future<CardModalViewModel> open(String cardId, {PinCoordinate? pin}) async {
    final provider = cardModalViewModelProvider((cardId: cardId, pin: pin));
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(provider, (_, __) {});
    await container.read(provider.future);
    return container.read(provider.notifier);
  }

  CardModalViewData state(String cardId, {PinCoordinate? pin}) {
    return container
        .read(cardModalViewModelProvider((cardId: cardId, pin: pin)))
        .requireValue;
  }

  (double, double) positionOf(CardModalViewData state) {
    return (state.card.latitude, state.card.longitude);
  }

  group('地図アプリで開く場所', () {
    test('ピンから開いたら、そのピンの座標', () async {
      const pin = (latitude: 34.5, longitude: 135.5);
      await open('A', pin: pin);

      expect(positionOf(state('A', pin: pin)), (34.5, 135.5));
    });

    test('「マップで見る」から開いたら、表示中の座標の種類の最初のピン', () async {
      await open('A');
      expect(positionOf(state('A')), (35.69, 139.77));
    });

    test('蓋の位置を表示していれば、蓋の位置', () async {
      coordinateType = MapCoordinateType.position;
      await open('A');

      expect(positionOf(state('A')), (35.68, 139.76));
    });

    test('配布地点のないカードを配布場所で開いたら、蓋の位置', () async {
      await open('B');

      expect(positionOf(state('B')), (35.68, 139.76));
    });
  });

  group('別アプリで開く', () {
    const pin = (latitude: 35.69, longitude: 139.77);

    test('Android では、Google マップをすぐ開く', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final viewModel = await open('A', pin: pin);

      await viewModel.onTapOpenInOtherApp();

      verify(
        () => navigationService.openUrl(
          any(that: startsWith('https://maps.google.com/')),
          external: true,
        ),
      ).called(1);
      verifyNever(
        () => navigationService.showChoice(options: any(named: 'options')),
      );
    });

    test('iOS では選んでもらい、選んだ地図アプリで開く', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final viewModel = await open('A', pin: pin);

      for (final (index, url) in [
        (0, 'https://maps.apple.com'),
        (1, 'https://maps.google.com/'),
      ]) {
        when(
          () => navigationService.showChoice(options: any(named: 'options')),
        ).thenAnswer((_) async => index);

        await viewModel.onTapOpenInOtherApp();

        verify(
          () => navigationService.openUrl(
            any(that: startsWith(url)),
            external: true,
          ),
        ).called(1);
      }
    });

    test('iOS で選ばずに閉じたら、何も開かない', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final viewModel = await open('A', pin: pin);

      await viewModel.onTapOpenInOtherApp();

      verifyNever(
        () =>
            navigationService.openUrl(any(), external: any(named: 'external')),
      );
    });
  });

  group('取得済み', () {
    test('未取得なら、確かめずに取得済みにする', () async {
      final viewModel = await open('A');

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
      final viewModel = await open('A');

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

    test('取得済みが変わると、表示も変わる', () async {
      await open('A');

      alreadyGet.add({'A'});
      await pumpEventQueue();

      expect(state('A').alreadyGet, isTrue);
      expect(state('A').alreadyGetActionButtonTitle, '未取得に戻す');
    });

    test('保存に失敗したら知らせる', () async {
      when(
        () => alreadyGetCardUseCase.save(id: 'A'),
      ).thenAnswer((_) async => const Result.failure(PersistenceException()));
      final viewModel = await open('A');

      await viewModel.onTapAlreadyGetButton();

      verify(
        () => navigationService.showFailure(
          title: '取得状態を保存できませんでした',
          exception: any(named: 'exception', that: isA<PersistenceException>()),
        ),
      ).called(1);
    });
  });
}
