import '/domain/entity/manhole_card_contact.dart';
import '/infra/dao/realm_contact_dao.dart';

class RealmContactMapper {
  static ManholeCardContact convertToEntity({
    required RealmContactDAO dao,
  }) {
    return ManholeCardContact(
      address: dao.address,
      id: dao.id,
      latitude: dao.latitude,
      longitude: dao.longitude,
      name: dao.name,
      nameUrl: dao.nameUrl,
      other: dao.other,
      phoneNumber: dao.phoneNumber,
      time: dao.time,
      timeOther: dao.timeOther,
    );
  }

  static RealmContactDAO convertFromEntity({
    required ManholeCardContact entity,
  }) {
    return RealmContactDAO(
      entity.id,
      entity.address,
      entity.latitude,
      entity.longitude,
      entity.name,
      entity.nameUrl,
      entity.other,
      entity.phoneNumber,
      entity.time,
      entity.timeOther,
    );
  }
}
