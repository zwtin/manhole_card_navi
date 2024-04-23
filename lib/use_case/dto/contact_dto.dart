import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_dto.freezed.dart';

@freezed
abstract class ContactDTO with _$ContactDTO {
  const factory ContactDTO({
    required String id,
    required String name,
    required String nameUrl,
    required String address,
    required String phoneNumber,
    required double latitude,
    required double longitude,
    required String other,
    required String time,
    required String timeOther,
  }) = _ContactDTO;
  const ContactDTO._();
}
