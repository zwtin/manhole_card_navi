import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/result.dart';
import '/domain/repository/push_notification_repository.dart';
import '/infra/repository_impl/push_notification_repository_impl.dart';

final pushNotificationUseCaseProvider =
    Provider.autoDispose<PushNotificationUseCase>(
  (ref) {
    final pushNotificationUseCase = PushNotificationUseCase(
      ref.watch(pushNotificationRepositoryProvider),
    );
    ref.onDispose(pushNotificationUseCase.dispose);
    return pushNotificationUseCase;
  },
);

class PushNotificationUseCase {
  PushNotificationUseCase(
    this._pushNotificationRepository,
  );

  final PushNotificationRepository _pushNotificationRepository;

  final _logger = Logger();

  Future<Result<void>> requestPermission() async {
    return _pushNotificationRepository.requestPermission();
  }

  void dispose() {
    _logger.d('PushNotificationUseCase dispose');
  }
}
