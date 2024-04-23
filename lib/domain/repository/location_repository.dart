import '/domain/entity/result.dart';

abstract class LocationRepository {
  Future<Result<void>> requestPermission();
}
