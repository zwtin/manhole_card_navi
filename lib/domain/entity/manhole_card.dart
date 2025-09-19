import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_contacts.dart';
import '/domain/entity/manhole_card_distribution_state.dart';
import '/domain/entity/manhole_card_image.dart';
import '/domain/entity/manhole_card_prefecture.dart';
import '/domain/entity/manhole_card_volume.dart';

part 'manhole_card.freezed.dart';

@freezed
abstract class ManholeCard with _$ManholeCard {
  const factory ManholeCard({
    required String id,
    required double latitude,
    required double longitude,
    required String name,
    required DateTime publicationDate,
    required ManholeCardDistributionState distributionState,
    required String distributionLinkText,
    required String distributionLinkUrl,
    required String distributionText,
    required String distributionOther,
    required ManholeCardContacts contacts,
    required ManholeCardImage image,
    required ManholeCardPrefecture prefecture,
    required ManholeCardVolume volume,
  }) = _ManholeCard;
  const ManholeCard._();
}

