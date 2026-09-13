import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_router.dart';

/// 最前面に表示されている画面。
@immutable
class CurrentRoute {
  const CurrentRoute({
    required this.pageKey,
    required this.matchedLocation,
    required this.uri,
    required this.pathParameters,
  });

  factory CurrentRoute.fromState(GoRouterState state) {
    return CurrentRoute(
      pageKey: state.pageKey,
      matchedLocation: state.matchedLocation,
      uri: state.uri,
      pathParameters: state.pathParameters,
    );
  }

  /// 画面の `GoRouterState.of(context).pageKey` と一致するキー。
  ///
  /// go で表示した画面はパス（`/map/card/:cardId` のようなパラメータ埋め込み前）ごとに
  /// 1 つで、push で積んだ画面は積むたびに別のキーになる。
  final ValueKey<String> pageKey;

  /// パスパラメータを埋めたパス（例: `/map/card/27-226-B001`）。
  final String matchedLocation;

  /// クエリを含む現在地。push で積んだ画面では積む前の現在地のまま。
  final Uri uri;

  final Map<String, String> pathParameters;
}

/// GoRouter の遷移を監視し、最前面の画面を公開する。
///
/// PV の送信（useScreenView）と、マップがモーダル表示中かの判定に使う。ダイアログ
/// など GoRouter を通さない表示は含まない。
final currentRouteProvider =
    NotifierProvider<CurrentRouteNotifier, CurrentRoute?>(
  CurrentRouteNotifier.new,
);

class CurrentRouteNotifier extends Notifier<CurrentRoute?> {
  @override
  CurrentRoute? build() {
    final router = ref.watch(routerProvider);
    void onChanged() {
      // Navigator が Page を差し替える最中（Widget の build 中）に通知されることが
      // あり、その場で state を変えると Riverpod が例外を投げるため次に回す。
      scheduleMicrotask(() => state = _read(router));
    }

    router.routerDelegate.addListener(onChanged);
    ref.onDispose(() => router.routerDelegate.removeListener(onChanged));
    return _read(router);
  }

  static CurrentRoute? _read(GoRouter router) {
    if (router.routerDelegate.currentConfiguration.isEmpty) {
      return null;
    }
    return CurrentRoute.fromState(router.state);
  }
}
