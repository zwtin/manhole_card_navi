import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  PushNotificationRepositoryImpl(
    this._messaging,
    this._crashlytics,
  );

  final FirebaseMessaging _messaging;
  final CrashlyticsDataSource _crashlytics;

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
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }
}
