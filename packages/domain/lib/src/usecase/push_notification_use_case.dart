import 'package:riverpod/riverpod.dart';

import 'package:domain/src/core/result.dart';
import 'package:domain/src/repository/push_notification_repository.dart';

final pushNotificationUseCaseProvider =
    Provider<PushNotificationUseCase>(
  (ref) => PushNotificationUseCase(
    ref.watch(pushNotificationRepositoryProvider),
  ),
);

class PushNotificationUseCase {
  PushNotificationUseCase(
    this._pushNotificationRepository,
  );

  final PushNotificationRepository _pushNotificationRepository;

  Future<Result<void>> requestPermission() async {
    return _pushNotificationRepository.requestPermission();
  }
}
