import 'package:domain/domain.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

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
