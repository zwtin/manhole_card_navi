import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

/// data の Repository が共有して使う DataSource。起動時に 1 回だけ作る。
class Infrastructure {
  Infrastructure._({
    required this.preferences,
    required this.packageInfo,
    required this.crashlytics,
    required this.remoteConfig,
    required this.masterDataLocal,
    required this.masterDataRemote,
    required this.cardImage,
    required this.analytics,
    required this.auth,
    required this.pushNotification,
  });

  /// 部品を作り、使える状態にする。Firebase の初期化の後に呼ぶ。
  ///
  /// 通信できなくても止まらない。Remote Config は取れなければ前回の値で続ける。
  static Future<Infrastructure> initialize() async {
    final remoteConfig = RemoteConfigDataSource(
      FirebaseRemoteConfig.instance,
      // 開発では、Remote Config を変えたらすぐ確かめられるように毎回取り直す。
      minimumFetchInterval: _isDevelopment ? Duration.zero : _fetchInterval,
    );
    await remoteConfig.activate();
    return Infrastructure._(
      preferences: PreferencesDataSource(
        await StreamingSharedPreferences.instance,
      ),
      packageInfo: PackageInfoDataSource(await PackageInfo.fromPlatform()),
      crashlytics: CrashlyticsDataSource(FirebaseCrashlytics.instance),
      remoteConfig: remoteConfig,
      masterDataLocal: MasterDataLocalDataSource.inApplicationSupport(),
      masterDataRemote: MasterDataRemoteDataSource(FirebaseFirestore.instance),
      cardImage: CardImageDataSource.withDeviceCache(),
      analytics: AnalyticsDataSource(FirebaseAnalytics.instance),
      auth: AuthDataSource(FirebaseAuth.instance),
      pushNotification: PushNotificationDataSource(FirebaseMessaging.instance),
    );
  }

  static const _isDevelopment =
      String.fromEnvironment('flavor') == 'development';
  static const _fetchInterval = Duration(hours: 12);

  final PreferencesDataSource preferences;
  final PackageInfoDataSource packageInfo;
  final CrashlyticsDataSource crashlytics;
  final RemoteConfigDataSource remoteConfig;

  /// 読み込んだカードをメモリに持つので、Repository どうしで同じものを使う。
  final MasterDataLocalDataSource masterDataLocal;

  final MasterDataRemoteDataSource masterDataRemote;
  final CardImageDataSource cardImage;
  final AnalyticsDataSource analytics;
  final AuthDataSource auth;
  final PushNotificationDataSource pushNotification;
}
