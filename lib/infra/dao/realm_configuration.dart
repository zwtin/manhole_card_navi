import 'package:realm/realm.dart';

import '/infra/dao/realm_card_dao.dart';
import '/infra/dao/realm_distribution_point_dao.dart';
import '/infra/dao/realm_prefecture_dao.dart';
import '/infra/dao/realm_volume_dao.dart';

/// ローカル DB（Realm）を開くための共通設定。
///
/// スキーマは全アクセス経路で同じものを使う。マスターデータは Firestore から
/// いつでも再取得できるため、スキーマ変更時はマイグレーションせずローカル DB を
/// 作り直す（[shouldDeleteIfMigrationNeeded]）。取得済みカードは
/// SharedPreferences で管理しているため、作り直しても失われない。
class RealmConfiguration {
  RealmConfiguration._();

  static Realm open() {
    return Realm(
      Configuration.local(
        [
          RealmCardDAO.schema,
          RealmDistributionPointDAO.schema,
          RealmPrefectureDAO.schema,
          RealmVolumeDAO.schema,
        ],
        shouldDeleteIfMigrationNeeded: true,
      ),
    );
  }
}
