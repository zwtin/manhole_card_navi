import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_data/check_master_update_view_data.dart';

final checkMasterUpdateViewModelProvider = NotifierProvider.autoDispose<
    CheckMasterUpdateViewModel, CheckMasterUpdateViewData>(
  CheckMasterUpdateViewModel.new,
);

/// 起動時にマスターデータを更新し、利用規約の同意状況で次の画面を決める ViewModel。
class CheckMasterUpdateViewModel
    extends AutoDisposeNotifier<CheckMasterUpdateViewData> {
  late final AnalyticsUseCase _analyticsUseCase;
  late final CheckMasterUpdateUseCase _checkMasterUpdateUseCase;
  late final CheckTermsOfServiceAgreeUseCase _checkTermsOfServiceAgreeUseCase;
  late final NavigationService _navigationService;

  @override
  CheckMasterUpdateViewData build() {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _checkMasterUpdateUseCase = ref.watch(checkMasterUpdateUseCaseProvider);
    _checkTermsOfServiceAgreeUseCase = ref.watch(
      checkTermsOfServiceAgreeUseCaseProvider,
    );
    _navigationService = ref.watch(navigationServiceProvider);
    return const CheckMasterUpdateViewData();
  }

  Future<void> onLoad() async {
    await _updateMasterIfNeeded();
    final needAgree = await _checkNeedAgree();
    if (needAgree) {
      _navigationService.goToTutorial();
    } else {
      _navigationService.goToCheckTermsOfServiceUpdate();
    }
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'check_master_update_view',
      },
    );
  }

  /// マスターデータの更新が必要なら更新する。失敗したら成功するまでやり直す。
  Future<void> _updateMasterIfNeeded() async {
    while (true) {
      state = state.copyWith(isLoading: true);
      final needUpdateResult = await _checkMasterUpdateUseCase.getNeedUpdate();
      state = state.copyWith(isLoading: false);
      final bool needUpdate;
      switch (needUpdateResult) {
        case Failure(:final exception):
          await _showUpdateFailure(exception);
          continue;
        case Success(:final value):
          needUpdate = value;
      }
      if (!needUpdate) {
        return;
      }

      state = state.copyWith(isLoading: true);
      final updateResult = await _checkMasterUpdateUseCase.updateMaster();
      state = state.copyWith(isLoading: false);
      if (updateResult case Failure(:final exception)) {
        await _showUpdateFailure(exception);
        continue;
      }
      return;
    }
  }

  Future<void> _showUpdateFailure(DomainException exception) async {
    await _navigationService.showFailure(
      title: 'マスターデータを更新できませんでした',
      exception: exception,
    );
  }

  /// 利用規約への同意が必要か。確認に失敗したら成功するまでやり直す。
  Future<bool> _checkNeedAgree() async {
    while (true) {
      state = state.copyWith(isLoading: true);
      final result = await _checkTermsOfServiceAgreeUseCase.getNeedAgree();
      state = state.copyWith(isLoading: false);
      if (result case Failure(:final exception)) {
        await _navigationService.showFailure(
          title: '利用規約の同意状況を確認できませんでした',
          exception: exception,
        );
        continue;
      }
      return (result as Success<bool>).value;
    }
  }
}
