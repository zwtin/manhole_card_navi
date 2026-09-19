import 'package:domain/domain.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

import '../exception/domain_exception_converter.dart';
import '../service/failure_recorder.dart';

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  PushNotificationRepositoryImpl(
    this._messaging,
    this._failureRecorder,
  );

  final _logger = Logger();
  final FirebaseMessaging _messaging;
  final FailureRecorder _failureRecorder;

  @override
  Future<Result<void>> requestPermission() {
    return _failureRecorder.guard(
      () async {
        await _messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      },
      convert: DomainExceptionConverter.fromPlatform,
    );
  }

  void dispose() {
    _logger.d('PushNotificationRepositoryImpl dispose');
  }
}
