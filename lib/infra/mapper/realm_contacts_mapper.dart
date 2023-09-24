import '/domain/entity/manhole_card_contacts.dart';
import '/infra/dao/realm_contact_dao.dart';

class RealmContactsMapper {
  static List<RealmContactDAO> convertFromModel({
    required ManholeCardContacts model,
  }) {
    return model.map(
      (element) {
        return RealmContactDAO(
          element.id,
          element.address,
          element.latitude,
          element.longitude,
          element.name,
          element.other,
          element.phoneNumber,
        );
      },
    ).toList();
  }
}
