import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/entity/manhole_card_contact.dart';

part 'manhole_card_contacts.freezed.dart';

@freezed
abstract class ManholeCardContacts with _$ManholeCardContacts {
  const factory ManholeCardContacts({
    required List<ManholeCardContact> list,
  }) = _ManholeCardContacts;
  const ManholeCardContacts._();

  Iterable<T> map<T>(T Function(ManholeCardContact) toElement) {
    return list.map(toElement);
  }
}
