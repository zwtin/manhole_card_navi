import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
sealed class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent.appOpen() = AppOpen;

  const factory AnalyticsEvent.screenView({
    required String screenName,
    @Default(<String, Object>{}) Map<String, Object> parameters,
  }) = ScreenView;

  /// [host] は取ろうとした配信元、[osError] は OS が返したエラー
  /// （`WRONG_VERSION_NUMBER` など。なければ空）、[statusCode] は応答があった
  /// 場合の状態（応答がなければ 0）。
  const factory AnalyticsEvent.imageLoadFailed({
    required String host,
    required String errorRuntimeType,
    required String osError,
    required int statusCode,
  }) = ImageLoadFailed;
}
