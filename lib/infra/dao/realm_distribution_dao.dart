import 'package:realm/realm.dart';

part 'realm_distribution_dao.g.dart';

@RealmModel()
class $RealmDistributionDAO {
  @PrimaryKey()
  late String id;
  late String other;
  late String state;
}
