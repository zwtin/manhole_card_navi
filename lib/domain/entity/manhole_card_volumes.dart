import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_volume.dart';

part 'manhole_card_volumes.freezed.dart';

@freezed
abstract class ManholeCardVolumes implements _$ManholeCardVolumes {
  const factory ManholeCardVolumes({
    required List<ManholeCardVolume> list,
  }) = _ManholeCardVolumes;
  const ManholeCardVolumes._();

  // Result<void> unfavor({required Answer answer}) {
  //   if (!favorAnswers.map((e) => e.id).contains(answer.id)) {
  //     return Result.failure(
  //       OTException(
  //         title: 'エラー',
  //         text: 'お気に入りの解除に失敗しました',
  //       ),
  //     );
  //   }
  //   favorAnswers.removeWhere((element) => element.id == answer.id);
  //
  //   if (answer.favoredUsers.map((e) => e.id).contains(id)) {
  //     answer.favoredUsers.removeWhere((element) => element.id == id);
  //   }
  //
  //   return const Result.success(null);
  // }
}
