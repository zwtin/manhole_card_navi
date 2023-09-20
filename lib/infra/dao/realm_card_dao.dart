import 'package:realm/realm.dart';

import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';

part 'realm_card_dao.g.dart';

@RealmModel()
class _RealmCardDAO {
  @PrimaryKey()
  late String id;
  late String name;
  late List<$RealmPrefectureDAO> prefectures;
  late List<$RealmVolumeDAO> volumes;
}
