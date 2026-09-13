import 'package:hooks_riverpod/hooks_riverpod.dart';

/// main.dart の ProviderScope で app パッケージの実装に差し替える。
final navigationServiceProvider = Provider<NavigationService>(
  (ref) =>
      throw UnimplementedError('navigationServiceProvider must be overridden'),
);

/// 画面遷移とダイアログ表示の窓口。
///
/// ViewModel が BuildContext に触れずに遷移を指示できるようにするため、Domain 層に
/// interface を置き、app パッケージ（go_router）で実装する。テストではモックに
/// 差し替えて、どの遷移が指示されたかを検証できる。
abstract class NavigationService {
  /// 起動時チェック: マスターデータの更新確認へ進む。
  void goToCheckMasterUpdate();

  /// 起動時チェック: 利用規約の更新確認へ進む。
  void goToCheckTermsOfServiceUpdate();

  /// 起動時チェック: 初回のチュートリアルへ進む。
  void goToTutorial();

  /// 起動時チェックを終えてタブ画面へ進む。戻る操作でチェック画面に戻らない。
  void goToHome();

  /// チュートリアルの後に利用規約の同意画面を積む。
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
    required String imageUrl,
    required String imageSubUrl,
    required bool alreadyGet,
    required String heroTag,
  });

  /// マップタブへ切り替え、そのタブを先頭まで戻してからカードのモーダルを表示する。
  void showCardOnMap({required String cardId});

  /// 最前面の画面を閉じる。
  void pop();

  /// OK ボタンだけのアラートを表示し、閉じられるまで待つ。
  Future<void> showAlert({
    required String title,
    required String message,
    String buttonTitle = 'OK',
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
