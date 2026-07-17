import '/domain/entity/result.dart';
import '/domain/entity/search_condition.dart';

abstract class SearchConditionRepository {
  Future<Result<void>> save({
    required SearchCondition searchCondition,
  });
}
