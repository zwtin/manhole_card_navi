import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/src/router/app_router.dart';
import 'package:app/src/router/go_router_navigation_service.dart';
import 'package:domain/domain.dart';

final navigationServiceProvider = Provider<NavigationService>(
  (ref) => GoRouterNavigationService(ref.watch(routerProvider)),
);

/// 画面遷移とダイアログ表示の窓口。
abstract class NavigationService {
  void goToCheckMasterUpdate();

  void goToCheckTermsOfServiceUpdate();

  void goToTutorial();

  /// 起動時チェックを終えてタブ画面へ進む。戻る操作でチェック画面に戻らない。
  void goToHome();

  Future<void> pushTermsOfServiceAgree();

  /// 利用規約を積む。起動時チェック中はタブの外、設定タブからはタブの中に積む。
  Future<void> pushTermsOfService();

  /// プライバシーポリシーを積む。積む場所は [pushTermsOfService] と同じ。
  Future<void> pushPrivacyPolicy();

  /// 設定タブから「アプリの使い方」を積む。
  Future<void> pushHowToUse();

  /// 設定タブからライセンスを積む。
  Future<void> pushLicense();

  /// 検索条件画面をタブの外に全画面で表示する。
  Future<void> presentSearchCondition();

  /// マップタブにカードのモーダルを表示する。
  ///
  /// [latitude] / [longitude] はタップしたピンの座標。配布場所マップでは 1 枚の
  /// カードに複数のピンがあるため、カード ID だけでは位置が決まらない。
  void presentCardModal({
    required String cardId,
    required double latitude,
    required double longitude,
  });

  /// 表示中のタブにカード詳細を積む。
  Future<void> pushCardDetail({required String cardId});

  /// カード画像の拡大表示をタブの外にフェードで表示する。
  Future<void> presentImageDetail({
    required String cardId,
    required bool alreadyGet,
    required String heroTag,
  });

  /// マップタブへ切り替え、そのタブを先頭まで戻してからカードのモーダルを表示する。
  void showCardOnMap({required String cardId});

  void pop();

  /// OK ボタンだけのアラートを表示し、閉じられるまで待つ。
  Future<void> showAlert({
    required String title,
    required String message,
    String buttonTitle = 'OK',
  });

  /// 失敗をアラートで知らせ、閉じられるまで待つ。
  ///
  /// [title] には何に失敗したか（例: 「マスターデータを更新できませんでした」）を
  /// 渡す。本文は [exception] の種類から決まる。
  Future<void> showFailure({
    required String title,
    required DomainException exception,
  });

  /// OK / キャンセルのアラートを表示し、OK が押されたら true を返す。
  Future<bool> showConfirm({
    required String title,
    required String message,
    String okButtonTitle = 'OK',
    String cancelButtonTitle = 'キャンセル',
  });

  /// URL を開く。[external] が true なら外部アプリ、false ならアプリ内ブラウザで開く。
  Future<void> openUrl(String url, {bool external = false});
}
