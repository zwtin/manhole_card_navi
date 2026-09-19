import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../core/result.dart';
import '../repository/push_notification_repository.dart';

/// UseCase は状態を持たないので、画面ごとに分けずアプリ全体で 1 つ。
final pushNotificationUseCaseProvider =
    Provider<PushNotificationUseCase>(
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
