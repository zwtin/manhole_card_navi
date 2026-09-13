import 'package:freezed_annotation/freezed_annotation.dart';

part 'shell_view_data.freezed.dart';

@freezed
abstract class ShellViewData with _$ShellViewData {
  const factory ShellViewData({
    /// カードを取得済みにした回数。増えるたびにクラッカーのアニメーションを流す。
    @Default(0) int partyCount,
  }) = _ShellViewData;
}
