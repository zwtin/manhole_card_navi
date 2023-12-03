import 'package:freezed_annotation/freezed_annotation.dart';

part 'manhole_card_contact.freezed.dart';

@freezed
abstract class ManholeCardContact with _$ManholeCardContact {
  const factory ManholeCardContact({
    required String address,
    required String id,
    required double latitude,
    required double longitude,
    required String name,
    required String nameUrl,
    required String other,
    required String phoneNumber,
    required String time,
    required String timeOther,
  }) = _ManholeCardContact;
  const ManholeCardContact._();
}
