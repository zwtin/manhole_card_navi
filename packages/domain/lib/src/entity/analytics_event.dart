import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
sealed class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent.appOpen() = AppOpen;

  const factory AnalyticsEvent.screenView({
    required String screenName,
    @Default(<String, Object>{}) Map<String, Object> parameters,
  }) = ScreenView;
}
