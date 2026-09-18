import 'package:riverpod/riverpod.dart';

import '../entity/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final pushNotificationRepositoryProvider =
    Provider.autoDispose<PushNotificationRepository>(
      (ref) =>
          throw UnimplementedError(
            'pushNotificationRepositoryProvider must be overridden',
          ),
    );

abstract class PushNotificationRepository {
  Future<Result<void>> requestPermission();
}
