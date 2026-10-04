import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mapper/map_markers_view_data_mapper.dart';
import '../mapper/modal_card_view_data_mapper.dart';
import '../router/app_router.dart';
import '../router/navigation_service.dart';
import '../view_data/card_modal_view_data.dart';

/// カードのモーダルの引数。[pin] はタップしたピンの座標で、カード詳細の
/// 「マップで見る」から開いたときは null になる。
typedef CardModalArgs = ({String cardId, PinCoordinate? pin});

final cardModalViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<CardModalViewModel, CardModalViewData, CardModalArgs>(
      CardModalViewModel.new,
    );

/// マップタブでピンをタップしたときに出るカードのモーダルの ViewModel。
class CardModalViewModel
    extends AutoDisposeFamilyAsyncNotifier<CardModalViewData, CardModalArgs> {
  late final AlreadyGetCardUseCase _alreadyGetCardUseCase;
  late final AnalyticsUseCase _analyticsUseCase;
  late final CardUseCase _cardUseCase;
  late final NavigationService _navigationService;
  late final SearchConditionUseCase _searchConditionUseCase;

  @override
  Future<CardModalViewData> build(CardModalArgs arg) async {
    _alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _cardUseCase = ref.watch(cardUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);
    _searchConditionUseCase = ref.watch(searchConditionUseCaseProvider);

    final subscription = _alreadyGetCardUseCase.watch().listen((cardIds) {
      final current = state.valueOrNull;
      if (current == null) {
        return;
      }
      state = AsyncData(
        current.copyWith(alreadyGet: cardIds.contains(arg.cardId)),
      );
    });
    ref.onDispose(subscription.cancel);

    final result = await _cardUseCase.get(id: arg.cardId);
    if (result case Failure(:final exception)) {
      unawaited(
        _navigationService.showFailure(
          title: 'カード情報を取得できませんでした',
          exception: exception,
        ),
      );
      throw exception;
    }
    final card = (result as Success<ManholeCard>).value;

    final alreadyGetCardIds = await _alreadyGetCardUseCase.watch().first;
    return CardModalViewData(
      card: ModalCardViewDataMapper.toViewData(
        card: card,
        position: await _positionOf(card),
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
  Future<Coordinate> _positionOf(ManholeCard card) async {
    final pin = arg.pin;
    if (pin != null) {
      return Coordinate(latitude: pin.latitude, longitude: pin.longitude);
    }
    final condition = await _searchConditionUseCase.watch().first;
    return MapMarkersViewDataMapper.firstPinOf(
          card,
          condition.map.coordinateType,
        ) ??
        card.position;
  }
}
