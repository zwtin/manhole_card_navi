import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_image.dart';

part 'manhole_card_images.freezed.dart';

@freezed
abstract class ManholeCardImages
    with _$ManholeCardImages, Iterable<ManholeCardImage> {
  const factory ManholeCardImages({
    required List<ManholeCardImage> list,
  }) = _ManholeCardImages;
  const ManholeCardImages._();
}
