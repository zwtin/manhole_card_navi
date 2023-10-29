import '/use_case/dto/already_get_card_dto.dart';

abstract class AlreadyGetCardQueryService {
  Stream<List<AlreadyGetCardDTO>> getStream();
}
