import '/domain/entity/result.dart';
import '/use_case/dto/already_get_card_dto.dart';

abstract class AlreadyGetCardQueryService {
  Future<Result<List<AlreadyGetCardDTO>>> get();
  Stream<List<AlreadyGetCardDTO>> getStream();
}
