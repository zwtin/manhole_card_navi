import 'dart:io';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router/navigation_service.dart';
import '../view_data/check_app_update_view_data.dart';

final checkAppUpdateViewModelProvider = NotifierProvider.autoDispose<
    CheckAppUpdateViewModel, CheckAppUpdateViewData>(
  CheckAppUpdateViewModel.new,
);

/// 起動時にアプリの強制アップデートが必要か確認する画面の ViewModel。
class CheckAppUpdateViewModel
    extends AutoDisposeNotifier<CheckAppUpdateViewData> {
  /// App Store のアプリ ID（マンホールカードナビ）
  static const _iosAppStoreId = '6466788859';

  /// Play Store のパッケージ名（本番）
  static const _androidPackageName = 'com.zwtin.manholecardnavi';

  late final AnalyticsUseCase _analyticsUseCase;
  late final CheckAppUpdateUseCase _checkAppUpdateUseCase;
  late final NavigationService _navigationService;
  late final UserUseCase _userUseCase;

  @override
  CheckAppUpdateViewData build() {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _checkAppUpdateUseCase = ref.watch(checkAppUpdateUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);
    _userUseCase = ref.watch(userUseCaseProvider);
    return const CheckAppUpdateViewData();
  }

  Future<void> onLoad() async {
    await _signIn();
    // 取得に失敗したとき・ストアから戻ったときは、確認が通るまでやり直す。
    while (true) {
      state = state.copyWith(isLoading: true);
      final result = await _checkAppUpdateUseCase.getNeedUpdate();
      state = state.copyWith(isLoading: false);
      if (result case Failure(:final exception)) {
        await _navigationService.showFailure(
          title: 'アプリのバージョンを確認できませんでした',
          exception: exception,
        );
        continue;
      }
      final needAppUpdate = (result as Success<bool>).value;
      if (needAppUpdate) {
        await _navigationService.showAlert(
          title: 'バージョンエラー',
          message: '最新のバージョンがリリースされています。アプリをアップデートしてください。',
          buttonTitle: 'ストアを開く',
        );
        await _openStore();
        continue;
      }
      _navigationService.goToCheckMasterUpdate();
      return;
    }
  }

  /// 起動時チェックの最初に、利用者を識別できる状態にする（匿名ログイン）。以降の
  /// イベントに利用者の ID が付くよう、アプリを開いたイベントもここで送る。
  ///
  /// 初回だけ通信が要る。できなければ、できるまでやり直す。
  Future<void> _signIn() async {
    while (true) {
      state = state.copyWith(isLoading: true);
      final result = await _userUseCase.signIn();
      state = state.copyWith(isLoading: false);
      if (result case Failure(:final exception)) {
        await _navigationService.showFailure(
          title: 'アプリの準備ができませんでした',
          exception: exception,
        );
        continue;
      }
      await _analyticsUseCase.send(event: const AnalyticsEvent.appOpen());
      return;
    }
  }

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      event: const AnalyticsEvent.screenView(
        screenName: 'check_app_update_view',
      ),
    );
  }

  /// ストア（App Store / Play Store）を開く。
  Future<void> _openStore() async {
    if (Platform.isIOS) {
      await _navigationService.openUrl(
        'https://apps.apple.com/jp/app/id$_iosAppStoreId',
        external: true,
      );
    } else if (Platform.isAndroid) {
      // フレーバーによってパッケージ名が変わるため、
      // ストア遷移先は本番のパッケージ名を固定で指定する。
      await _navigationService.openUrl(
        'https://play.google.com/store/apps/details?id=$_androidPackageName',
        external: true,
      );
    }
  }
}
