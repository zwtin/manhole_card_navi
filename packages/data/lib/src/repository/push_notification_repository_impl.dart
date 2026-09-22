import 'package:data/src/datasource/crashlytics_data_source.dart';
import 'package:data/src/datasource/push_notification_data_source.dart';
import 'package:data/src/mapper/domain_exception_mapper.dart';
import 'package:domain/domain.dart';

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  PushNotificationRepositoryImpl(
    this._pushNotification,
    this._crashlytics,
  );

  final PushNotificationDataSource _pushNotification;
  final CrashlyticsDataSource _crashlytics;

  @override
  Future<Result<void>> requestPermission() async {
    try {
      await _pushNotification.requestPermission();
      return const Result.success(null);
    } on Exception catch (error, stackTrace) {
      _crashlytics.recordNonFatal(error, stackTrace);
      return Result.failure(DomainExceptionMapper.from(error));
    }
  }
}
