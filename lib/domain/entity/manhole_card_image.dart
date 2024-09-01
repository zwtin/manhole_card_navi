import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_image.freezed.dart';

@freezed
abstract class ManholeCardImage with _$ManholeCardImage {
  const factory ManholeCardImage({
    required String id,
    required String colorOriginal,
    required String colorResized,
    required String colorFrameGreen,
    required String colorFrameRed,
    required String colorFrameYellow,
    required String grayOriginal,
    required String grayResized,
    required String grayFrameGreen,
    required String grayFrameRed,
    required String grayFrameYellow,
  }) = _ManholeCardImage;
  const ManholeCardImage._();
}
