import 'package:manhole_card_navi/domain/entity/manhole_card_prefecture.dart';
import 'package:manhole_card_navi/infra/dao/realm_prefecture_dao.dart';

class RealmPrefectureMapper {
  static ManholeCardPrefecture convertToModel({
    required RealmPrefectureDAO dao,
  }) {
    return ManholeCardPrefecture(
      id: dao.id,
      name: dao.name,
    );
  }
}
