import 'package:realm/realm.dart';

part 'realm_volume_dao.g.dart';

@RealmModel()
class $RealmVolumeDAO {
  @PrimaryKey()
  late String id;
  late String name;
}
