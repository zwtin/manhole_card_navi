import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card.dart';

part 'manhole_cards.freezed.dart';

@freezed
abstract class ManholeCards with _$ManholeCards, Iterable<ManholeCard> {
  const factory ManholeCards({
    required List<ManholeCard> list,
  }) = _ManholeCards;
  const ManholeCards._();
}
