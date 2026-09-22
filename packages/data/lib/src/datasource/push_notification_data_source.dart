import 'package:firebase_messaging/firebase_messaging.dart';

/// プッシュ通知。許可されたかどうかは使わないので返さない。
class PushNotificationDataSource {
  PushNotificationDataSource(this._messaging);

  final FirebaseMessaging _messaging;

  Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
