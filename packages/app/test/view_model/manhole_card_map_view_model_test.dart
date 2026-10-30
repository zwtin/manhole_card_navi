import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/src/router/current_route.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/manhole_card_map_view_data.dart';
import 'package:app/src/view_model/manhole_card_map_view_model.dart';
import 'package:domain/domain.dart';

import 'test_doubles.dart';

void main() {
  // マーカーの枠の画像（アセット）を読むため。
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCardUseCase cardUseCase;
  late MockLocationUseCase locationUseCase;
  late MockNavigationService navigationService;
  late StreamController<bool> permission;
  late StreamController<SearchCondition> searchCondition;
  late StreamController<Set<String>> alreadyGet;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    final alreadyGetCardUseCase = MockAlreadyGetCardUseCase();
    final analyticsUseCase = MockAnalyticsUseCase();
    final searchConditionUseCase = MockSearchConditionUseCase();
    cardUseCase = MockCardUseCase();
    locationUseCase = MockLocationUseCase();
    navigationService = MockNavigationService();
    permission = StreamController.broadcast();
    searchCondition = StreamController.broadcast();
    alreadyGet = StreamController.broadcast();

    when(
      () => alreadyGetCardUseCase.watch(),
    ).thenAnswer((_) => watching(<String>{}, alreadyGet.stream));
    when(
      () => analyticsUseCase.send(event: any(named: 'event')),
    ).thenAnswer((_) async => const Result.success(null));
    when(() => searchConditionUseCase.watch()).thenAnswer(
      (_) => watching(SearchCondition.initial(), searchCondition.stream),
    );
    when(
      () => cardUseCase.fetchAll(),
    ).thenAnswer((_) async => Result.success([manholeCard(id: 'A')]));
    // 画像を取れないので、ピンは立たない。ピンを使うテストだけ差し替える。
    when(
      () => cardUseCase.fetchImage(cardId: any(named: 'cardId')),
    ).thenAnswer((_) async => const Result.failure(NotFoundException()));
    when(
      () => locationUseCase.watchPermissionGranted(),
    ).thenAnswer((_) => permission.stream);
    when(
      () => locationUseCase.isPermissionGranted(),
    ).thenAnswer((_) async => const Result.success(true));
    when(() => locationUseCase.getCurrentLocation()).thenAnswer(
      (_) async =>
          const Result.success(Coordinate(latitude: 35.0, longitude: 135.0)),
    );
    when(
      () => navigationService.showAlert(
        title: any(named: 'title'),
        message: any(named: 'message'),
        buttonTitle: any(named: 'buttonTitle'),
      ),
    ).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        alreadyGetCardUseCaseProvider.overrideWithValue(alreadyGetCardUseCase),
        analyticsUseCaseProvider.overrideWithValue(analyticsUseCase),
        cardUseCaseProvider.overrideWithValue(cardUseCase),
        currentRouteProvider.overrideWith(FakeCurrentRoute.new),
        locationUseCaseProvider.overrideWithValue(locationUseCase),
        navigationServiceProvider.overrideWithValue(navigationService),
        searchConditionUseCaseProvider.overrideWithValue(
          searchConditionUseCase,
        ),
      ],
    );
    // autoDispose の ViewModel がテスト中に破棄されないよう購読しておく。
    container.listen(manholeCardMapViewModelProvider, (_, __) {});
  });

  tearDown(() async {
    container.dispose();
    await Future.wait([
      permission.close(),
      searchCondition.close(),
      alreadyGet.close(),
    ]);
  });

  ManholeCardMapViewModel viewModel() {
    return container.read(manholeCardMapViewModelProvider.notifier);
  }

  ManholeCardMapViewData state() {
    return container.read(manholeCardMapViewModelProvider);
  }

  Future<void> go(String location) async {
    (container.read(currentRouteProvider.notifier) as FakeCurrentRoute).go(
      location,
    );
    await pumpEventQueue();
  }

  ({double latitude, double longitude, bool animated})? cameraMove() {
    final move = state().cameraMove;
    if (move == null) {
      return null;
    }
    return (
      latitude: move.latitude,
      longitude: move.longitude,
      animated: move.animated,
    );
  }

  group('ピン', () {
    test('ピンを押すと、そのピンの座標でカードのモーダルを開く', () async {
      when(
        () => cardUseCase.fetchImage(cardId: 'A'),
      ).thenAnswer((_) async => Result.success(pngBytes));
      await viewModel().onLoad();

      await viewModel().onTapMarker(state().markers.single.id);

      verify(
        () => navigationService.presentCardModal(
          cardId: 'A',
          latitude: 35.69,
          longitude: 139.77,
        ),
      ).called(1);
    });

    test('押したピンが地図にもうなければ、アラートを出す', () async {
      await viewModel().onTapMarker('ない');

      verify(
        () => navigationService.showAlert(
          title: 'エラー',
          message: 'カード情報の取得に失敗しました',
        ),
      ).called(1);
      verifyNever(
        () => navigationService.presentCardModal(
          cardId: any(named: 'cardId'),
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      );
    });
  });

  group('カードのモーダル', () {
    test('ピンから開くと、表示エリアを縮め、ピンへ滑らかにカメラを動かす', () async {
      await go('/map/card/A?latitude=35.69&longitude=139.77');

      expect(state().isShowingCardModal, isTrue);
      expect(cameraMove(), (
        latitude: 35.69,
        longitude: 139.77,
        animated: true,
      ));
    });

    test('「マップで見る」から開くと、カードのピンへすぐ動かす', () async {
      await go('/map/card/A');

      expect(state().isShowingCardModal, isTrue);
      expect(cameraMove(), (
        latitude: 35.69,
        longitude: 139.77,
        animated: false,
      ));
    });

    test('モーダルと詳細を行き来しただけなら、カメラは動かさない', () async {
      await go('/map/card/A?latitude=35.69&longitude=139.77');
      final opened = state().cameraMove;

      await go('/map/card/A/detail');
      await go('/map/card/A?latitude=35.69&longitude=139.77');

      expect(state().cameraMove, opened);
    });

    test('閉じると、表示エリアを戻す', () async {
      await go('/map/card/A?latitude=35.69&longitude=139.77');

      await go('/map');

      expect(state().isShowingCardModal, isFalse);
    });
  });

  group('現在地', () {
    test('位置情報の許可が届いたら、現在地を表示して現在地へ動かす', () async {
      permission.add(true);
      await pumpEventQueue();

      expect(state().myLocationEnabled, isTrue);
      expect(cameraMove(), (latitude: 35.0, longitude: 135.0, animated: false));
    });

    test('同じ場所で現在地ボタンを続けて押しても、そのたびに動かす', () async {
      await viewModel().updateMyLocationEnabled();
      final ids = <int>[];
      for (var i = 0; i < 2; i++) {
        await viewModel().onTapCurrentLocationButton();
        ids.add(state().cameraMove!.id);
      }

      expect(ids.toSet(), hasLength(2));
      expect(cameraMove(), (latitude: 35.0, longitude: 135.0, animated: false));
    });

    test('位置情報を使えなければ、現在地ボタンでアラートを出す', () async {
      when(
        () => locationUseCase.isPermissionGranted(),
      ).thenAnswer((_) async => const Result.success(false));
      await viewModel().updateMyLocationEnabled();

      await viewModel().onTapCurrentLocationButton();

      expect(state().cameraMove, isNull);
      verify(
        () => navigationService.showAlert(
          title: 'エラー',
          message: '位置情報を取得できません。設定を変更してください。',
        ),
      ).called(1);
    });
  });

  test('検索条件が変わると、見出し・絞り込みの数・ピンの幅を変える', () async {
    await viewModel().onLoad();
    expect(state().pinWidth, 72);

    searchCondition.add(
      const SearchCondition(
        common: CommonSearchCondition(volumeIds: {'0000'}),
        map: MapSearchCondition(
          coordinateType: MapCoordinateType.position,
          pinSize: MapPinSize.largest,
        ),
      ),
    );
    await pumpEventQueue();

    expect(state().navigationTitle, '蓋マップ');
    expect(state().activeFilterCount, 1);
    expect(state().pinWidth, 144);
  });

  test('ピンの大きさだけが変わったときは、ピンを作り直さない', () async {
    when(
      () => cardUseCase.fetchImage(cardId: 'A'),
    ).thenAnswer((_) async => Result.success(pngBytes));
    await viewModel().onLoad();
    await pumpEventQueue();
    clearInteractions(cardUseCase);

    searchCondition.add(
      const SearchCondition(map: MapSearchCondition(pinSize: MapPinSize.small)),
    );
    await pumpEventQueue();

    expect(state().pinWidth, 51);
    verifyNever(() => cardUseCase.fetchImage(cardId: any(named: 'cardId')));
  });
}
