import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:manhole_card_navi/domain/entity/manhole_card_contact.dart';
import 'package:manhole_card_navi/domain/entity/manhole_card_distribution.dart';
import 'package:manhole_card_navi/domain/entity/manhole_card_image.dart';
import 'package:manhole_card_navi/domain/entity/manhole_card_prefecture.dart';
import 'package:manhole_card_navi/domain/entity/manhole_card_volume.dart';

part 'manhole_card.freezed.dart';

@freezed
abstract class ManholeCard implements _$ManholeCard {
  const factory ManholeCard({
    required String id,
    required double latitude,
    required double longitude,
    required String name,
    required DateTime publicationDate,
    required List<ManholeCardContact> contacts,
    required List<ManholeCardDistribution> distributions,
    required List<ManholeCardImage> images,
    required List<ManholeCardPrefecture> prefectures,
    required List<ManholeCardVolume> volumes,
  }) = _ManholeCard;
  const ManholeCard._();
}
