import '/domain/entity/result.dart';
import '/use_case/dto/map_marker_dto.dart';

abstract class PositionCardsQueryService {
  Future<Result<List<MapMarkerDTO>>> fetch();
}
