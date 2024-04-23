import '/domain/entity/manhole_card.dart';
import '/domain/entity/result.dart';

abstract class AlreadyGetCardRepository {
  Future<Result<void>> save({
    required ManholeCard manholeCard,
  });
  Future<Result<void>> delete({
    required ManholeCard manholeCard,
  });
}
