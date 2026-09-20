import 'package:data/data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

/// data の Repository が共有して使う部品。起動時に 1 回だけ作る。
class Infrastructure {
  Infrastructure._({
    required this.preferences,
    required this.packageInfo,
    required this.crashlytics,
    required this.failureRecorder,
    required this.remoteConfig,
    required this.masterData,
    required this.cardImage,
  });

  /// 部品を作り、使える状態にする。Firebase の初期化の後に呼ぶ。
  ///
  /// 通信できなくても止まらない。Remote Config は取れなければ前回の値で続ける。
  static Future<Infrastructure> initialize() async {
    final crashlytics = CrashlyticsDataSource(FirebaseCrashlytics.instance);
    final remoteConfig = RemoteConfigDataSource(
      FirebaseRemoteConfig.instance,
      // 開発では、Remote Config を変えたらすぐ確かめられるように毎回取り直す。
      minimumFetchInterval: _isDevelopment ? Duration.zero : _fetchInterval,
    );
    await remoteConfig.activate();
    return Infrastructure._(
      preferences: await StreamingSharedPreferences.instance,
      packageInfo: await PackageInfo.fromPlatform(),
      crashlytics: crashlytics,
      failureRecorder: FailureRecorder(crashlytics),
      remoteConfig: remoteConfig,
      masterData: MasterDataLocalDataSource.inApplicationSupport(),
      cardImage: CardImageDataSource.withDeviceCache(FirebaseAnalytics.instance),
    );
  }

  static const _isDevelopment =
      String.fromEnvironment('flavor') == 'development';
  static const _fetchInterval = Duration(hours: 12);

  final StreamingSharedPreferences preferences;
  final PackageInfo packageInfo;
  final CrashlyticsDataSource crashlytics;
  final FailureRecorder failureRecorder;
  final RemoteConfigDataSource remoteConfig;

  /// 読み込んだカードをメモリに持つので、Repository どうしで同じものを使う。
  final MasterDataLocalDataSource masterData;

  final CardImageDataSource cardImage;
}
