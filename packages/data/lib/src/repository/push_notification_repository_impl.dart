import 'package:domain/domain.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  final _logger = Logger();
  final _failureRecorder = FailureRecorder();
  final _messaging = FirebaseMessaging.instance;

  @override
  Future<Result<void>> requestPermission() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      return _failureRecorder.failure(
        DomainExceptionConverter.fromPlatform(error, stackTrace),
        stackTrace,
      );
    }
  }

  void dispose() {
    _logger.d('PushNotificationRepositoryImpl dispose');
  }
}
