import 'package:realm/realm.dart';

part 'realm_contact_dao.realm.dart';

@RealmModel()
class $RealmContactDAO {
  @PrimaryKey()
  late String id;
  late String address;
  late double latitude;
  late double longitude;
  late String name;
  late String nameUrl;
  late String other;
  late String phoneNumber;
  late String time;
  late String timeOther;
}
