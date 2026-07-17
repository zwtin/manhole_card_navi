import '/domain/entity/result.dart';
import '/domain/entity/search_condition.dart';

abstract class SearchConditionQueryService {
  Future<Result<SearchCondition>> get();
  Stream<SearchCondition> getStream();
}
