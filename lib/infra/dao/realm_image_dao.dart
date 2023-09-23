import 'package:realm/realm.dart';

part 'realm_image_dao.g.dart';

@RealmModel()
class $RealmImageDAO {
  @PrimaryKey()
  late String id;
  late String name;
  late String path;
}
