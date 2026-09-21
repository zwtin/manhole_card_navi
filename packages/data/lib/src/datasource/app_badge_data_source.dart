import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';

/// アプリアイコンのバッジ。static な API を、テストで差し替えられるように包む。
class AppBadgeDataSource {
  const AppBadgeDataSource();

  Future<void> updateCount(int count) {
    return FlutterAppBadgeControl.updateBadgeCount(count);
  }

  Future<void> remove() => FlutterAppBadgeControl.removeBadge();
}
