import '/domain/entity/result.dart';
import '/use_case/dto/list_prefecture_dto.dart';

abstract class ListCardsQueryService {
  Future<Result<List<ListPrefectureDTO>>> fetch();
}
