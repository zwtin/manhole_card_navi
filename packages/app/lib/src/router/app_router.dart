import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view/card_modal_page.dart';
import '../view/check_app_update_page.dart';
import '../view/check_master_update_page.dart';
import '../view/check_terms_of_service_agree_page.dart';
import '../view/check_terms_of_service_update_page.dart';
import '../view/custom_introduction_page.dart';
import '../view/detail_page.dart';
import '../view/image_detail_page.dart';
import '../view/licenses_page.dart';
import '../view/manhole_card_list_page.dart';
import '../view/manhole_card_map_page.dart';
import '../view/privacy_policy_page.dart';
import '../view/search_condition_page.dart';
import '../view/setting_page.dart';
import '../view/terms_of_service_page.dart';
import 'modal_bottom_sheet_page.dart';
import 'shell_scaffold.dart';

/// 画面のパス。
abstract final class AppRoutePath {
  // ── 起動時チェック（タブの外） ──
  static const checkAppUpdate = '/check-app-update';
  static const checkMasterUpdate = '/check-master-update';
  static const checkTermsOfServiceUpdate = '/check-terms-of-service-update';
  static const tutorial = '/tutorial';
  static const termsOfServiceAgree = '/tutorial/agree';

  // ── タブの外に積む画面 ──
  static const termsOfService = '/terms-of-service';
  static const privacyPolicy = '/privacy-policy';
  static const searchCondition = '/search-condition';
  static const imageDetail = '/image-detail';

  // ── マップタブ ──
  static const map = '/map';
  static const cardModalPrefix = '/map/card/';
  static String cardModal(String cardId) => '$cardModalPrefix$cardId';
  static String mapCardDetail(String cardId) => '${cardModal(cardId)}/detail';

  // ── リストタブ ──
  static const list = '/list';
  static String listCardDetail(String cardId) => '/list/detail/$cardId';

  // ── 設定タブ ──
  static const setting = '/setting';
  static const settingHowToUse = '/setting/how-to-use';
  static const settingTermsOfService = '/setting/terms-of-service';
  static const settingPrivacyPolicy = '/setting/privacy-policy';
  static const settingLicense = '/setting/license';
}

/// カード画像の拡大表示に渡す引数。
class ImageDetailArgs {
  const ImageDetailArgs({
    required this.cardId,
    required this.imageUrl,
    required this.imageSubUrl,
    required this.alreadyGet,
    required this.heroTag,
  });

  final String cardId;
  final String imageUrl;
  final String imageSubUrl;
  final bool alreadyGet;
  final String heroTag;
}

/// タブの外（全画面）に積む画面が使う Navigator。
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

// 各ブランチ（タブ）専用の NavigatorKey。タブごとに独立した遷移スタックを持つ。
final _mapNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'map-tab');
final _listNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'list-tab');
final _settingNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'setting-tab',
);

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutePath.checkAppUpdate,
    routes: [
      // 起動時チェックは前の画面を置き換えながら進むので、遷移アニメーションを付けない。
      GoRoute(
        path: AppRoutePath.checkAppUpdate,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CheckAppUpdatePage(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.checkMasterUpdate,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CheckMasterUpdatePage(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.checkTermsOfServiceUpdate,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CheckTermsOfServiceUpdatePage(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.tutorial,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CustomIntroductionPage(isTutorial: true),
        ),
        routes: [
          GoRoute(
            path: 'agree',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const CheckTermsOfServiceAgreePage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePath.termsOfService,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const TermsOfServicePage(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.privacyPolicy,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const PrivacyPolicyPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.searchCondition,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const SearchConditionPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePath.imageDetail,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          // 背面のカード詳細を透かしながら、ドラッグで閉じられるようにする。
          opaque: false,
          child: ImageDetailPage(args: state.extra! as ImageDetailArgs),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          key: state.pageKey,
          child: ShellScaffold(navigationShell: navigationShell),
        ),
        branches: [
          // ── Branch 0: マップタブ ──
          StatefulShellBranch(
            navigatorKey: _mapNavigatorKey,
            // タブを開く前からデータを読み込んでおく。
            preload: true,
            routes: [
              GoRoute(
                path: AppRoutePath.map,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ManholeCardMapPage(),
                ),
                routes: [
                  // /map/card/:cardId → カードのモーダル
                  GoRoute(
                    path: 'card/:cardId',
                    pageBuilder: (context, state) => ModalBottomSheetPage(
                      key: state.pageKey,
                      child: CardModalPage(
                        cardId: state.pathParameters['cardId']!,
                        latitude: double.tryParse(
                          state.uri.queryParameters['latitude'] ?? '',
                        ),
                        longitude: double.tryParse(
                          state.uri.queryParameters['longitude'] ?? '',
                        ),
                      ),
                    ),
                    routes: [
                      // /map/card/:cardId/detail → モーダルから開くカード詳細
                      GoRoute(
                        path: 'detail',
                        pageBuilder: (context, state) => MaterialPage(
                          key: state.pageKey,
                          child: DetailPage(
                            cardId: state.pathParameters['cardId']!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // ── Branch 1: リストタブ ──
          StatefulShellBranch(
            navigatorKey: _listNavigatorKey,
            preload: true,
            routes: [
              GoRoute(
                path: AppRoutePath.list,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ManholeCardListPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'detail/:cardId',
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: DetailPage(
                        cardId: state.pathParameters['cardId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // ── Branch 2: 設定タブ ──
          StatefulShellBranch(
            navigatorKey: _settingNavigatorKey,
            preload: true,
            routes: [
              GoRoute(
                path: AppRoutePath.setting,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const SettingPage(),
                ),
                routes: [
                  GoRoute(
                    path: 'how-to-use',
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const CustomIntroductionPage(isTutorial: false),
                    ),
                  ),
                  GoRoute(
                    path: 'terms-of-service',
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const TermsOfServicePage(),
                    ),
                  ),
                  GoRoute(
                    path: 'privacy-policy',
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const PrivacyPolicyPage(),
                    ),
                  ),
                  GoRoute(
                    path: 'license',
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const LicensesPage(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
