import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_volume.dart';

part 'manhole_card_volumes.freezed.dart';

@freezed
abstract class ManholeCardVolumes with _$ManholeCardVolumes {
  const factory ManholeCardVolumes({
    required List<ManholeCardVolume> list,
  }) = _ManholeCardVolumes;
  const ManholeCardVolumes._();

  Iterable<T> map<T>(T Function(ManholeCardVolume) toElement) {
    return list.map(toElement);
  }
}
