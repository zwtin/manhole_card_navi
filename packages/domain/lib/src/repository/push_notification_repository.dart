import 'package:riverpod/riverpod.dart';

import '../core/result.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final pushNotificationRepositoryProvider =
    Provider<PushNotificationRepository>(
      (ref) =>
          throw UnimplementedError(
            'pushNotificationRepositoryProvider must be overridden',
          ),
    );

abstract class PushNotificationRepository {
  Future<Result<void>> requestPermission();
}
