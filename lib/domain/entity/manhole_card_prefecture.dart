import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_prefecture.freezed.dart';

@freezed
abstract class ManholeCardPrefecture with _$ManholeCardPrefecture {
  const factory ManholeCardPrefecture({
    required String id,
    required String name,
  }) = _ManholeCardPrefecture;
  const ManholeCardPrefecture._();
}
