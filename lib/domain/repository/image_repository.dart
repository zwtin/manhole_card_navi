import '/domain/entity/inquired_master_version.dart';
import '/domain/entity/manhole_card_image.dart';
import '/domain/entity/manhole_card_images.dart';
import '/domain/entity/result.dart';

abstract class ImageRepository {
  Future<Result<ManholeCardImages>> fetchMaster({
    required InquiredMasterVersion inquiredMasterVersion,
  });
  Future<Result<void>> deleteMaster();
  Future<Result<void>> saveMaster({
    required ManholeCardImages manholeCardImages,
  });
  Future<Result<ManholeCardImage>> get({
    required String id,
  });
}
