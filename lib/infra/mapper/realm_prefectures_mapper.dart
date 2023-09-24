import '/domain/entity/manhole_card_prefectures.dart';
import '/infra/dao/realm_prefecture_dao.dart';

class RealmPrefecturesMapper {
  static List<RealmPrefectureDAO> convertFromModel({
    required ManholeCardPrefectures model,
  }) {
    return model.map(
      (element) {
        return RealmPrefectureDAO(
          element.id,
          element.name,
        );
      },
    ).toList();
  }
}
