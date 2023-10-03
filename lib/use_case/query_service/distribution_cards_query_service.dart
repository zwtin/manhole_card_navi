import '/domain/entity/result.dart';
import '/use_case/dto/map_card_dto.dart';

abstract class DistributionCardsQueryService {
  Future<Result<List<MapCardDTO>>> fetch();
}
