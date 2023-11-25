import '/domain/entity/result.dart';
import '/use_case/dto/list_card_dto.dart';

abstract class ListCardsQueryService {
  Future<Result<List<ListCardDTO>>> fetch();
}
