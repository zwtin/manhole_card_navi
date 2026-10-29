import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/navigation_service.dart';
import 'package:app/src/view_data/check_app_update_view_data.dart';
import 'package:domain/domain.dart';

final checkAppUpdateViewModelProvider = NotifierProvider.autoDispose<
  CheckAppUpdateViewModel,
  CheckAppUpdateViewData
>(CheckAppUpdateViewModel.new);

/// 起動時にアプリの強制アップデートが必要か確認する画面の ViewModel。
class CheckAppUpdateViewModel
    extends AutoDisposeNotifier<CheckAppUpdateViewData> {
  /// App Store のアプリ ID（マンホールカードナビ）
  static const _iosAppStoreId = '6466788859';

  /// Play Store のパッケージ名（本番）
  static const _androidPackageName = 'com.zwtin.manholecardnavi';

  AnalyticsUseCase get _analyticsUseCase => ref.read(analyticsUseCaseProvider);
  AppInfoUseCase get _appInfoUseCase => ref.read(appInfoUseCaseProvider);
  NavigationService get _navigationService =>
      ref.read(navigationServiceProvider);
  UserUseCase get _userUseCase => ref.read(userUseCaseProvider);

  @override
  CheckAppUpdateViewData build() {
    return const CheckAppUpdateViewData();
  }

  Future<void> onLoad() async {
    await _signIn();
    // 取得に失敗したとき・ストアから戻ったときは、確認が通るまでやり直す。
    while (true) {
      state = state.copyWith(isLoading: true);
      final result = await _appInfoUseCase.getNeedUpdate();
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

  Future<void> _openStore() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        await _navigationService.openUrl(
          'https://apps.apple.com/jp/app/id$_iosAppStoreId',
          external: true,
        );
      case TargetPlatform.android:
        // フレーバーによってパッケージ名が変わるため、
        // ストア遷移先は本番のパッケージ名を固定で指定する。
        await _navigationService.openUrl(
          'https://play.google.com/store/apps/details?id=$_androidPackageName',
          external: true,
        );
      default:
        break;
    }
  }
}
