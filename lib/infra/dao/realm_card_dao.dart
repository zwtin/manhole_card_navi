import 'package:realm/realm.dart';

import '/infra/dao/realm_distribution_point_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';

part 'realm_card_dao.realm.dart';

@RealmModel()
class $RealmCardDAO {
  @PrimaryKey()
  late String id;

  /// マンホールの座標（カード記載の度分秒を 10 進に変換したもの）。
  late double latitude;
  late double longitude;
  late String name;
  late DateTime publicationDate;
  late String distributionState;

  /// カード画像の Firebase Hosting 上のパス。
  late String image;

  /// 配布場所の HTML。
  late String distributionPlaceHtml;

  /// 在庫状況の HTML。
  late String stockHtml;

  /// 配布場所の座標（0〜複数）。
  late List<$RealmDistributionPointDAO> distributionPoints;
  late $RealmPrefectureDAO? prefecture;
  late $RealmVolumeDAO? volume;
}
