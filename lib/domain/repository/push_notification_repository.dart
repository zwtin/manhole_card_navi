import '/domain/entity/result.dart';

abstract class PushNotificationRepository {
  Future<Result<void>> requestPermission();
}
