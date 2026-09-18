import 'dart:io';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  @override
  CheckAppUpdateViewData build() {
    _analyticsUseCase = ref.watch(analyticsUseCaseProvider);
    _checkAppUpdateUseCase = ref.watch(checkAppUpdateUseCaseProvider);
    _navigationService = ref.watch(navigationServiceProvider);
    return const CheckAppUpdateViewData();
  }

  Future<void> onLoad() async {
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
      final needAppUpdateDTO = (result as Success<NeedAppUpdateDTO>).value;
      if (needAppUpdateDTO.value) {
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

  Future<void> sendScreenView() async {
    await _analyticsUseCase.send(
      name: 'screen_pv',
      parameters: {
        'screen_name': 'check_app_update_view',
      },
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
