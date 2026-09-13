import 'package:realm/realm.dart';

part 'realm_volume_dao.realm.dart';

@RealmModel()
class $RealmVolumeDAO {
  @PrimaryKey()
  late String id;
  late String name;
}
