import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_contacts.dart';
import '/domain/entity/manhole_card_distributions.dart';
import '/domain/entity/manhole_card_images.dart';
import '/domain/entity/manhole_card_prefectures.dart';
import '/domain/entity/manhole_card_volumes.dart';

part 'manhole_card.freezed.dart';

@freezed
abstract class ManholeCard with _$ManholeCard {
  const factory ManholeCard({
    required String id,
    required double latitude,
    required double longitude,
    required String name,
    required DateTime publicationDate,
    required ManholeCardContacts contacts,
    required ManholeCardDistributions distributions,
    required ManholeCardImages images,
    required ManholeCardPrefectures prefectures,
    required ManholeCardVolumes volumes,
  }) = _ManholeCard;
  const ManholeCard._();
}
