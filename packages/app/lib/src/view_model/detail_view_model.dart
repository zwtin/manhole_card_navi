import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/mapper/detail_card_view_data_mapper.dart';
import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/detail_card_view_data.dart';
import 'package:domain/domain.dart';

/// 引数はカード ID。
final detailViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<DetailViewModel, DetailCardViewData, String>(DetailViewModel.new);

class DetailViewModel
    extends AutoDisposeFamilyAsyncNotifier<DetailCardViewData, String> {
  AlreadyGetCardUseCase get _alreadyGetCardUseCase =>
      ref.read(alreadyGetCardUseCaseProvider);
  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);
  NavigationService get _navigationService =>
      ref.read(navigationServiceProvider);

  @override
  Future<DetailCardViewData> build(String cardId) async {
    final alreadyGetCardUseCase = ref.watch(alreadyGetCardUseCaseProvider);
    final cardUseCase = ref.watch(cardUseCaseProvider);
    final navigationService = ref.watch(navigationServiceProvider);

    final subscription = alreadyGetCardUseCase.watch().listen((cardIds) {
      final current = state.valueOrNull;
      if (current == null) {
        return;
      }
      state = AsyncData(current.copyWith(alreadyGet: cardIds.contains(cardId)));
    });
    ref.onDispose(subscription.cancel);

    final result = await cardUseCase.get(id: cardId);
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
    return DetailCardViewDataMapper.toViewData(
      card: card,
      alreadyGet: alreadyGetCardIds.contains(cardId),
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
      alreadyGet: current.alreadyGet,
      heroTag: heroTag,
    );
  }

  Future<void> onTapLink(String url) => _navigationService.openUrl(url);

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: AnalyticsEvent.screenView(
        screenName: 'detail_view',
        parameters: {'card_id': arg},
      ),
    );
  }
}
