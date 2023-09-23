import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_contact.dart';

part 'manhole_card_contacts.freezed.dart';

@freezed
abstract class ManholeCardContacts implements _$ManholeCardContacts {
  const factory ManholeCardContacts({
    required List<ManholeCardContact> list,
  }) = _ManholeCardContacts;
  const ManholeCardContacts._();
}
