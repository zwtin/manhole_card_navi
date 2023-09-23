import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_image.freezed.dart';

@freezed
abstract class ManholeCardImage implements _$ManholeCardImage {
  const factory ManholeCardImage({
    required String id,
    required String name,
    required String path,
  }) = _ManholeCardImage;
  const ManholeCardImage._();
}
