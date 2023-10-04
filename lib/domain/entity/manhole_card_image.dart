import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_image.freezed.dart';

@freezed
abstract class ManholeCardImage with _$ManholeCardImage {
  const factory ManholeCardImage({
    required String id,
    required String name,
  }) = _ManholeCardImage;
  const ManholeCardImage._();
}
