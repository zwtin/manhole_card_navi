import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_router.dart';
import 'go_router_navigation_service.dart';

/// domain パッケージが宣言した provider のうち、画面側で実装するものを差し替える。
/// main.dart の ProviderScope に渡す。
final List<Override> appProviderOverrides = [
  navigationServiceProvider.overrideWith(
    (ref) => GoRouterNavigationService(ref.watch(routerProvider)),
  ),
];
