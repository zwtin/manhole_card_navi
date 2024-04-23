import '/domain/entity/manhole_card_contact.dart';
import '/domain/entity/manhole_card_contacts.dart';
import '/infra/dao/realm_contact_dao.dart';

class RealmContactsMapper {
  static ManholeCardContacts convertToEntity({
    required List<RealmContactDAO> daoList,
  }) {
    return ManholeCardContacts(
      list: daoList.map(
        (element) {
          return ManholeCardContact(
            address: element.address,
            id: element.id,
            latitude: element.latitude,
            longitude: element.longitude,
            name: element.name,
            nameUrl: element.nameUrl,
            other: element.other,
            phoneNumber: element.phoneNumber,
            time: element.time,
            timeOther: element.timeOther,
          );
        },
      ).toList(),
    );
  }

  static List<RealmContactDAO> convertFromEntity({
    required ManholeCardContacts entity,
  }) {
    return entity.map(
      (element) {
        return RealmContactDAO(
          element.id,
          element.address,
          element.latitude,
          element.longitude,
          element.name,
          element.nameUrl,
          element.other,
          element.phoneNumber,
          element.time,
          element.timeOther,
        );
      },
    ).toList();
  }
}
