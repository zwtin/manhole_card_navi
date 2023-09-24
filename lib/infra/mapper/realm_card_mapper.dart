import '/domain/entity/manhole_card.dart';
import '/domain/entity/manhole_card_contacts.dart';
import '/domain/entity/manhole_card_distributions.dart';
import '/domain/entity/manhole_card_images.dart';
import '/domain/entity/manhole_card_prefectures.dart';
import '/domain/entity/manhole_card_volumes.dart';
import '/infra/dao/realm_card_dao.dart';

class RealmCardMapper {
  static ManholeCard convertToModel({
    required RealmCardDAO dao,
  }) {
    return ManholeCard(
      id: dao.id,
      latitude: dao.latitude,
      longitude: dao.longitude,
      name: dao.name,
      publicationDate: dao.publicationDate,
      contacts: const ManholeCardContacts(list: []),
      distributions: const ManholeCardDistributions(list: []),
      images: const ManholeCardImages(list: []),
      prefectures: const ManholeCardPrefectures(list: []),
      volumes: const ManholeCardVolumes(list: []),
    );
  }
}
