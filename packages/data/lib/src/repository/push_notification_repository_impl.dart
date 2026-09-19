import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:data/src/datasource/failure_recorder.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  PushNotificationRepositoryImpl(
    this._messaging,
    this._failureRecorder,
  );

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
      convert: DomainExceptionMapper.fromPlatform,
    );
  }
}
