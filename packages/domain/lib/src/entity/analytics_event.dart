import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
sealed class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent.appOpen() = AppOpen;

  const factory AnalyticsEvent.screenView({
    required String screenName,
    @Default(<String, Object>{}) Map<String, Object> parameters,
  }) = ScreenView;

  /// カード画像を取れなかった。[host] は取ろうとした配信元、[errorType] は
  /// 取れなかった理由の分類（data が付ける）、[statusCode] は応答があった場合の状態。
  const factory AnalyticsEvent.imageLoadFailed({
    required String host,
    required String errorType,
    required int statusCode,
  }) = ImageLoadFailed;
}
