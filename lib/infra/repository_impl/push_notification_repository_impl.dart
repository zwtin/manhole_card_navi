import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '/domain/entity/custom_exception.dart';
import '/domain/entity/result.dart';
import '/domain/repository/push_notification_repository.dart';

final pushNotificationRepositoryProvider =
    Provider.autoDispose<PushNotificationRepository>(
  (ref) {
    final pushNotificationRepository = PushNotificationRepositoryImpl();
    ref.onDispose(pushNotificationRepository.dispose);
    return pushNotificationRepository;
  },
);

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  final _logger = Logger();
  final _messaging = FirebaseMessaging.instance;

  @override
  Future<Result<void>> requestPermission() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return const Result.success(null);
    } on CustomException catch (customException) {
      return Result.failure(
        customException,
      );
    } on Exception catch (_) {
      return const Result.failure(
        CustomException(
          title: 'エラー',
          text: '通知にアクセスできませんでした。',
        ),
      );
    }
  }

  void dispose() {
    _logger.d('PushNotificationRepositoryImpl dispose');
  }
}
