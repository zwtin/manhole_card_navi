import 'package:realm/realm.dart';

import '/infra/dao/realm_contact_dao.dart';
import '/infra/dao/realm_image_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';

part 'realm_card_dao.realm.dart';

@RealmModel()
class $RealmCardDAO {
  @PrimaryKey()
  late String id;
  late double latitude;
  late double longitude;
  late String name;
  late DateTime publicationDate;
  late String distributionState;
  late String distributionLinkText;
  late String distributionLinkUrl;
  late String distributionText;
  late String distributionOther;
  late $RealmImageDAO? image;
  late $RealmPrefectureDAO? prefecture;
  late $RealmVolumeDAO? volume;
  late List<$RealmContactDAO> contacts;
}
