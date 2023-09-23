import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
abstract class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent({
    required String name,
    Map<String, Object>? parameters,
  }) = _AnalyticsEvent;
  const AnalyticsEvent._();
}
