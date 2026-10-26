import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/mapper/map_markers_view_data_mapper.dart';
import 'package:app/src/mapper/modal_card_view_data_mapper.dart';
import 'package:app/src/router/app_router.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/card_modal_view_data.dart';
import 'package:domain/domain.dart';

/// カードのモーダルの引数。[pin] はタップしたピンの座標で、カード詳細の
/// 「マップで見る」から開いたときは null になる。
typedef CardModalArgs = ({String cardId, PinCoordinate? pin});

final cardModalViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<CardModalViewModel, CardModalViewData, CardModalArgs>(
      CardModalViewModel.new,
    );

class CardModalViewModel
    extends AutoDisposeFamilyAsyncNotifier<CardModalViewData, CardModalArgs> {
  AlreadyGetCardUseCase get _alreadyGetCardUseCase =>
      ref.read(alreadyGetCardUseCaseProvider);
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);
  NavigationService get _navigationService =>
      ref.read(navigationServiceProvider);

  @override
  Future<CardModalViewData> build(CardModalArgs arg) async {
    final alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    final cardUseCase = ref.watch(cardUseCaseProvider);
    final navigationService = ref.watch(navigationServiceProvider);
    final searchConditionUseCase = ref.watch(searchConditionUseCaseProvider);

    final subscription = alreadyGetCardUseCase.watch().listen((cardIds) {
      final current = state.valueOrNull;
      if (current == null) {
        return;
      }
      state = AsyncData(
        current.copyWith(alreadyGet: cardIds.contains(arg.cardId)),
      );
    });
    ref.onDispose(subscription.cancel);

    final result = await cardUseCase.get(id: arg.cardId);
    if (result case Failure(:final exception)) {
      unawaited(
        navigationService.showFailure(
          title: 'カード情報を取得できませんでした',
          exception: exception,
        ),
      );
      throw exception;
    }
    final card = (result as Success<ManholeCard>).value;

    final alreadyGetCardIds = await alreadyGetCardUseCase.watch().first;
    return CardModalViewData(
      card: ModalCardViewDataMapper.toViewData(
        card: card,
        position: await _positionOf(card, searchConditionUseCase),
      ),
      alreadyGet: alreadyGetCardIds.contains(arg.cardId),
    );
  }

  Future<void> onTapDetailButton() async {
    await _navigationService.pushCardDetail(cardId: arg.cardId);
  }

  Future<void> onTapAlreadyGetButton() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final Result<void> result;
    if (!current.alreadyGet) {
      result = await _alreadyGetCardUseCase.save(id: arg.cardId);
    } else {
      final confirmed = await _navigationService.showConfirm(
        title: '確認',
        message: 'カードを未取得に戻してよろしいですか？',
      );
      if (!confirmed) {
        return;
      }
      result = await _alreadyGetCardUseCase.delete(id: arg.cardId);
    }
    if (result case Failure(:final exception)) {
      await _navigationService.showFailure(
        title: '取得状態を保存できませんでした',
        exception: exception,
      );
    }
  }

  Future<void> openGoogleMap() async {
    final card = state.valueOrNull?.card;
    if (card == null) {
      return;
    }
    final uri = Uri(
      scheme: 'https',
      host: 'maps.google.com',
      path: '/maps/search/',
      queryParameters: {
        'api': '1',
        'query': '${card.latitude},${card.longitude}',
      },
    );
    await _navigationService.openUrl(uri.toString(), external: true);
  }

  Future<void> openAppleMap() async {
    final card = state.valueOrNull?.card;
    if (card == null) {
      return;
    }
    final uri = Uri(
      scheme: 'https',
      host: 'maps.apple.com',
      queryParameters: {
        'q': card.name,
        'll': '${card.latitude},${card.longitude}',
      },
    );
    await _navigationService.openUrl(uri.toString(), external: true);
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: AnalyticsEvent.screenView(
        screenName: 'card_modal_view',
        parameters: {'card_id': arg.cardId},
      ),
    );
  }

  /// 「マップで見る」から開いたときは、マップがカメラを向けるのと同じピンにする。
  Future<Coordinate> _positionOf(
    ManholeCard card,
    SearchConditionUseCase searchConditionUseCase,
  ) async {
    final pin = arg.pin;
    if (pin != null) {
      return Coordinate(latitude: pin.latitude, longitude: pin.longitude);
    }
    final condition = await searchConditionUseCase.watch().first;
    return MapMarkersViewDataMapper.firstPinOf(
          card,
          condition.map.coordinateType,
        ) ??
        card.position;
  }
}
