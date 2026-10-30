import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:data/src/model/analytics_event_model.dart';

class AnalyticsDataSource {
  AnalyticsDataSource(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> send(AnalyticsEventModel event) {
    return _analytics.logEvent(name: event.name, parameters: event.parameters);
  }

  /// 以降に送るイベントに付ける利用者の ID。
  Future<void> setUserId(String id) => _analytics.setUserId(id: id);
}
