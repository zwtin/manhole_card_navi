import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:domain/src/entity/map_display_settings.dart';
import 'package:domain/src/entity/search_condition.dart';

part 'card_browsing_settings.freezed.dart';

/// 利用者が検索条件の画面でまとめて選び、まとめて保存する設定。片方だけが
/// 保存された状態を作らないよう、保存はこの単位で行う。
@freezed
abstract class CardBrowsingSettings with _$CardBrowsingSettings {
  const factory CardBrowsingSettings({
    @Default(SearchCondition()) SearchCondition searchCondition,
    @Default(MapDisplaySettings()) MapDisplaySettings mapDisplaySettings,
  }) = _CardBrowsingSettings;

  factory CardBrowsingSettings.initial() => const CardBrowsingSettings();
}
