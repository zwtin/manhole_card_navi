import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../mapper/detail_card_view_data_mapper.dart';
import '../view_data/detail_card_view_data.dart';

/// 引数はカード ID。
final detailViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<DetailViewModel, DetailCardViewData, String>(
  DetailViewModel.new,
);

/// カード詳細画面の ViewModel。
class DetailViewModel
    extends AutoDisposeFamilyAsyncNotifier<DetailCardViewData, String> {
  late final AlreadyGetCardQueryService _alreadyGetCardQueryService;
  late final AlreadyGetCardUseCase _alreadyGetCardUseCase;
  late final AnalyticsUseCase _analyticsUseCase;
  late final CardUseCase _cardUseCase;
  late final NavigationService _navigationService;

  @override
  Future<DetailCardViewData> build(String cardId) async {
    _alreadyGetCardQueryService = ref.watch(alreadyGetCardQueryServiceProvider);
    _alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _cardUseCase = ref.watch(cardUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);

    final subscription = _alreadyGetCardQueryService.getStream().listen((
      dtoList,
    ) {
      final current = state.valueOrNull;
      if (current == null) {
        return;
      }
      state = AsyncData(
        current.copyWith(
          alreadyGet: dtoList.any((dto) => dto.cardId == cardId),
        ),
      );
    });
    ref.onDispose(subscription.cancel);

    final result = await _cardUseCase.get(id: cardId);
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

    final alreadyGetResult = await _alreadyGetCardQueryService.get();
    return DetailCardViewDataMapper.convertToViewData(
      cardDTO: cardDTO,
      alreadyGet: alreadyGetResult is Success<List<AlreadyGetCardDTO>> &&
          alreadyGetResult.value.any((dto) => dto.cardId == cardId),
    );
  }

  Future<void> onTapCheckWithMapButton() async {
    _navigationService.showCardOnMap(cardId: arg);
  }

  Future<void> onTapAlreadyGetButton() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final Result<void> result;
    if (!current.alreadyGet) {
      result = await _alreadyGetCardUseCase.save(id: arg);
    } else {
      final confirmed = await _navigationService.showConfirm(
        title: '確認',
        message: 'カードを未取得に戻してよろしいですか？',
      );
      if (!confirmed) {
        return;
      }
      result = await _alreadyGetCardUseCase.delete(id: arg);
    }
    if (result case Failure(:final exception)) {
      await _navigationService.showFailure(
        title: '取得状態を保存できませんでした',
        exception: exception,
      );
    }
  }

  Future<void> onTapImage(String heroTag) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    await _navigationService.presentImageDetail(
      cardId: arg,
      imageUrl: current.imageUrl,
      imageSubUrl: current.imageSubUrl,
      alreadyGet: current.alreadyGet,
      heroTag: heroTag,
    );
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'detail_view',
        'card_id': arg,
      },
    );
  }
}
