import 'package:realm/realm.dart';

part 'realm_image_dao.realm.dart';

@RealmModel()
class $RealmImageDAO {
  @PrimaryKey()
  late String id;
  late String name;
}
