import 'package:realm/realm.dart';

part 'realm_distribution_point_dao.realm.dart';

/// 配布場所の座標。カードに埋め込んで持つ（単独では存在しない）。
@RealmModel(ObjectType.embeddedObject)
class $RealmDistributionPointDAO {
  late double latitude;
  late double longitude;
}
