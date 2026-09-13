import 'package:domain/domain.dart';

import '../dao/realm_prefecture_dao.dart';

class RealmPrefecturesMapper {
  static ManholeCardPrefectures convertToEntity({
    required List<RealmPrefectureDAO> daoList,
  }) {
    return ManholeCardPrefectures(
      list: daoList.map(
        (element) {
          return ManholeCardPrefecture(
            id: element.id,
            name: element.name,
          );
        },
      ).toList(),
    );
  }

  static List<RealmPrefectureDAO> convertFromEntity({
    required ManholeCardPrefectures entity,
  }) {
    return entity.map(
      (element) {
        return RealmPrefectureDAO(
          element.id,
          element.name,
        );
      },
    ).toList();
  }
}
