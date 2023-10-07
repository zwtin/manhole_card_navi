import '/domain/entity/manhole_card_prefecture.dart';
import '/infra/dao/realm_prefecture_dao.dart';

class RealmPrefectureMapper {
  static ManholeCardPrefecture convertToEntity({
    required RealmPrefectureDAO dao,
  }) {
    return ManholeCardPrefecture(
      id: dao.id,
      name: dao.name,
    );
  }

  static RealmPrefectureDAO convertFromEntity({
    required ManholeCardPrefecture entity,
  }) {
    return RealmPrefectureDAO(
      entity.id,
      entity.name,
    );
  }
}
