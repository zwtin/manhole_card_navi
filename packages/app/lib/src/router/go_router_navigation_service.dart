import 'dart:async';

import 'package:domain/domain.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mapper/error_message_mapper.dart';
import '../widget/app_alert.dart';
import 'app_router.dart';
import 'navigation_service.dart';

/// [NavigationService] の go_router による実装。
///
/// 起動時チェックの画面は前の画面へ戻れないよう go で置き換え、それ以外は push で
/// 積む。マップのモーダルは、どのカードを表示中かをマップが現在地から読めるよう
/// go で表す。
class GoRouterNavigationService implements NavigationService {
  GoRouterNavigationService(this._router, this._errorReporter);

  final GoRouter _router;
  final ErrorReporter _errorReporter;

  /// 最前面の画面のパス。
  String get _currentLocation => _router.state.matchedLocation;

  @override
  void goToCheckMasterUpdate() => _router.go(AppRoutePath.checkMasterUpdate);

  @override
  void goToCheckTermsOfServiceUpdate() =>
      _router.go(AppRoutePath.checkTermsOfServiceUpdate);

  @override
  void goToTutorial() => _router.go(AppRoutePath.tutorial);

  @override
  void goToHome() => _router.go(AppRoutePath.map);

  @override
  Future<void> pushTermsOfServiceAgree() async {
    await _router.push<void>(AppRoutePath.termsOfServiceAgree);
  }

  @override
  Future<void> pushTermsOfService() async {
    // 設定タブから開いたときはタブの中に積み、下タブを表示したままにする。
    await _router.push<void>(
      _currentLocation.startsWith(AppRoutePath.setting)
          ? AppRoutePath.settingTermsOfService
          : AppRoutePath.termsOfService,
    );
  }

  @override
  Future<void> pushPrivacyPolicy() async {
    await _router.push<void>(
      _currentLocation.startsWith(AppRoutePath.setting)
          ? AppRoutePath.settingPrivacyPolicy
          : AppRoutePath.privacyPolicy,
    );
  }

  @override
  Future<void> pushHowToUse() async {
    await _router.push<void>(AppRoutePath.settingHowToUse);
  }

  @override
  Future<void> pushLicense() async {
    await _router.push<void>(AppRoutePath.settingLicense);
  }

  @override
  Future<void> presentSearchCondition() async {
    await _router.push<void>(AppRoutePath.searchCondition);
  }

  @override
  void presentCardModal({
    required String cardId,
    required double latitude,
    required double longitude,
  }) {
    _router.go(
      Uri(
        path: AppRoutePath.cardModal(cardId),
        queryParameters: {
          'latitude': '$latitude',
          'longitude': '$longitude',
        },
      ).toString(),
    );
  }

  @override
  Future<void> pushCardDetail({required String cardId}) async {
    // モーダルから開いたときはマップタブ、それ以外（リスト）はリストタブに積む。
    await _router.push<void>(
      _currentLocation.startsWith(AppRoutePath.cardModalPrefix)
          ? AppRoutePath.mapCardDetail(cardId)
          : AppRoutePath.listCardDetail(cardId),
    );
  }

  @override
  Future<void> presentImageDetail({
    required String cardId,
    required String imageUrl,
    required String imageSubUrl,
    required bool alreadyGet,
    required String heroTag,
  }) async {
    await _router.push<void>(
      AppRoutePath.imageDetail,
      extra: ImageDetailArgs(
        cardId: cardId,
        imageUrl: imageUrl,
        imageSubUrl: imageSubUrl,
        alreadyGet: alreadyGet,
        heroTag: heroTag,
      ),
    );
  }

  @override
  void showCardOnMap({required String cardId}) {
    // マップタブのパスへ go すると、タブの切り替えと先頭まで戻す操作を兼ねる。
    // 座標を渡さないので、マップがカードの位置を調べてカメラを動かす。
    _router.go(AppRoutePath.cardModal(cardId));
  }

  @override
  void pop() => _router.pop();

  @override
  Future<void> showAlert({
    required String title,
    required String message,
    String buttonTitle = 'OK',
  }) async {
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return;
    }
    await showAppAlert(
      context,
      title: title,
      message: message,
      okButtonTitle: buttonTitle,
    );
  }

  @override
  Future<void> showFailure({
    required String title,
    required DomainException exception,
  }) async {
    // 時間をおけば直る失敗は、記録しても直せることがなく、件数に埋もれて調べる
    // べき失敗が見えにくくなるので記録しない。
    final needsInvestigation = switch (exception) {
      UnavailableException() => false,
      CorruptedDataException() ||
      NotFoundException() ||
      PersistenceException() ||
      UnknownException() =>
        true,
    };
    if (needsInvestigation) {
      unawaited(_errorReporter.recordFailure(exception, reason: title));
    }
    await showAlert(
      title: title,
      message: ErrorMessageMapper.messageOf(exception),
    );
  }

  @override
  Future<bool> showConfirm({
    required String title,
    required String message,
    String okButtonTitle = 'OK',
    String cancelButtonTitle = 'キャンセル',
  }) async {
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return false;
    }
    return showAppAlert(
      context,
      title: title,
      message: message,
      okButtonTitle: okButtonTitle,
      cancelButtonTitle: cancelButtonTitle,
    );
  }

  @override
  Future<void> openUrl(String url, {bool external = false}) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      return;
    }
    await launchUrl(
      uri,
      mode: external
          ? LaunchMode.externalApplication
          : LaunchMode.inAppWebView,
    );
  }
}
