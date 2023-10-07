import 'package:realm/realm.dart';

import '/infra/dao/realm_contact_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';

part 'realm_card_dao.g.dart';

@RealmModel()
class _RealmCardDAO {
  @PrimaryKey()
  late String id;
  late double latitude;
  late double longitude;
  late String name;
  late DateTime publicationDate;
  late String distributionState;
  late String distributionText;
  late String distributionUrl;
  late $RealmImageDAO? image;
  late $RealmPrefectureDAO? prefecture;
  late $RealmVolumeDAO? volume;
  late List<$RealmContactDAO> contacts;
}
