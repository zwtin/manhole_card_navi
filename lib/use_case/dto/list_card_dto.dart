import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_card_dto.freezed.dart';

@freezed
abstract class ListCardDTO with _$ListCardDTO {
  const factory ListCardDTO({
    required String id,
    required String name,

    /// カード画像の配信用フル URL（Firestore 格納値をそのまま利用）。
    required String imagePath,
    required String prefectureId,
    required String prefectureName,
    required String volumeId,
    required String volumeName,

    /// 配布状態の文字列値（'distributing' / 'stopped' / 'notClear'）。
    required String distributionState,
    required DateTime publicationDate,
  }) = _ListCardDTO;
  const ListCardDTO._();
}
