import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

/// 計測するイベント。何を計測するかはここで決め、計測サービスでの名前
/// （Firebase のイベント名など）への置き換えは data が行う。
@freezed
sealed class AnalyticsEvent with _$AnalyticsEvent {
  /// アプリを開いた。
  const factory AnalyticsEvent.appOpen() = AppOpen;

  /// 画面を表示した。[parameters] は画面ごとの補足（表示中のカードの ID など）。
  const factory AnalyticsEvent.screenView({
    required String screenName,
    @Default(<String, Object>{}) Map<String, Object> parameters,
  }) = ScreenView;
}
