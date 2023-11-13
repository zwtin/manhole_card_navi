import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_contact.dart';
import '/domain/entity/manhole_card_contacts.dart';
import '/domain/entity/result.dart';

abstract class ContactRepository {
  Future<Result<ManholeCardContacts>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCardContacts manholeCardContacts,
  });
  Future<Result<ManholeCardContact>> get({
    required String id,
  });
}
