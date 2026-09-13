import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_volume.freezed.dart';

@freezed
abstract class ManholeCardVolume with _$ManholeCardVolume {
  const factory ManholeCardVolume({
    required String id,
    required String name,
  }) = _ManholeCardVolume;
  const ManholeCardVolume._();
}
