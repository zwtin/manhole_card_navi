import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';

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
