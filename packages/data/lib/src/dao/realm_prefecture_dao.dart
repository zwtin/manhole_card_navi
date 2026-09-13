import 'package:realm/realm.dart';

part 'realm_prefecture_dao.realm.dart';

@RealmModel()
class $RealmPrefectureDAO {
  @PrimaryKey()
  late String id;
  late String name;
}
