import '/domain/entity/manhole_card_contact.dart';
import '/infra/dao/realm_contact_dao.dart';

class RealmContactMapper {
  static ManholeCardContact convertToModel({
    required RealmContactDAO dao,
  }) {
    return ManholeCardContact(
      address: dao.address,
      id: dao.id,
      latitude: dao.latitude,
      longitude: dao.longitude,
      name: dao.name,
      other: dao.other,
      phoneNumber: dao.phoneNumber,
    );
  }
}
