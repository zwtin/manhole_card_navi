import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_prefecture.dart';

part 'manhole_card_prefectures.freezed.dart';

@freezed
abstract class ManholeCardPrefectures
    with _$ManholeCardPrefectures, Iterable<ManholeCardPrefecture> {
  const factory ManholeCardPrefectures({
    required List<ManholeCardPrefecture> list,
  }) = _ManholeCardPrefectures;
  const ManholeCardPrefectures._();
}
