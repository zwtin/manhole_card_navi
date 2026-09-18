import 'dart:async';

import 'package:domain/domain.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mapper/modal_card_view_data_mapper.dart';
import '../view_data/card_modal_view_data.dart';
import 'manhole_card_map_view_model.dart';

/// カードのモーダルの引数。座標はタップしたピンの位置で、カード詳細の
/// 「マップで見る」から開いたときは null になる。
typedef CardModalArgs = ({String cardId, double? latitude, double? longitude});

final cardModalViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<CardModalViewModel, CardModalViewData, CardModalArgs>(
  CardModalViewModel.new,
);

/// マップタブでピンをタップしたときに出るカードのモーダルの ViewModel。
class CardModalViewModel
    extends AutoDisposeFamilyAsyncNotifier<CardModalViewData, CardModalArgs> {
  late final AlreadyGetCardQueryService _alreadyGetCardQueryService;
  late final AlreadyGetCardUseCase _alreadyGetCardUseCase;
  late final AnalyticsUseCase _analyticsUseCase;
  late final CardUseCase _cardUseCase;
  late final NavigationService _navigationService;

  @override
  Future<CardModalViewData> build(CardModalArgs arg) async {
    _alreadyGetCardQueryService = ref.watch(alreadyGetCardQueryServiceProvider);
    _alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _cardUseCase = ref.watch(cardUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);
    final mapViewModel = ref.read(manholeCardMapViewModelProvider.notifier);

    final subscription = _alreadyGetCardQueryService.getStream().listen((
      dtoList,
    ) {
      final current = state.valueOrNull;
      if (current == null) {
        return;
      }
      state = AsyncData(
        current.copyWith(
          alreadyGet: dtoList.any((dto) => dto.cardId == arg.cardId),
        ),
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
    final cardDTO = (result as Success<CardDTO>).value;

    final latitude = arg.latitude;
    final longitude = arg.longitude;
    final position = latitude != null && longitude != null
        ? LatLng(latitude, longitude)
        : await mapViewModel.findCardPosition(arg.cardId) ??
            LatLng(cardDTO.latitude, cardDTO.longitude);

    final alreadyGetResult = await _alreadyGetCardQueryService.get();
    return CardModalViewData(
      card: await ModalCardViewDataMapper.convertToViewData(
        cardDTO: cardDTO,
        position: position,
      ),
      alreadyGet: alreadyGetResult is Success<List<AlreadyGetCardDTO>> &&
          alreadyGetResult.value.any((dto) => dto.cardId == arg.cardId),
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
      name: 'screen_pv',
      parameters: {
        'screen_name': 'card_modal_view',
        'card_id': arg.cardId,
      },
    );
  }
}
