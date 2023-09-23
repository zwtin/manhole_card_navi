import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_volume.freezed.dart';

@freezed
abstract class ManholeCardVolume implements _$ManholeCardVolume {
  const factory ManholeCardVolume({
    required String id,
    required String name,
  }) = _ManholeCardVolume;
  const ManholeCardVolume._();
}
