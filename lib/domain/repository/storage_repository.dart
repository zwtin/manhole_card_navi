import '/domain/entity/result.dart';

abstract class StorageRepository {
  Future<Result<void>> delete({
    required String url,
  });
}
