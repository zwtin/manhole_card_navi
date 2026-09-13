import 'package:realm/realm.dart';

import 'realm_distribution_point_dao.dart';
import 'realm_prefecture_dao.dart';
import 'realm_volume_dao.dart';

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

  /// カード画像の配信用フル URL。
  late String image;

  /// カード画像の代替配信元のフル URL。[image] が取得できないときに使う。
  /// 代替を持たない master では空文字。
  late String imageSub;

  /// 配布場所の HTML。
  late String distributionPlaceHtml;

  /// 配布時間の HTML。
  late String distributionTimeHtml;

  /// 在庫状況の HTML。
  late String stockHtml;

  /// 配布場所の座標（0〜複数）。
  late List<$RealmDistributionPointDAO> distributionPoints;
  late $RealmPrefectureDAO? prefecture;
  late $RealmVolumeDAO? volume;
}
