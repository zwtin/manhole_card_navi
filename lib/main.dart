import 'dart:async';

import 'package:app/app.dart';
import 'package:data/data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'debug_proxy.dart';
import 'firebase_options.dart';

FutureOr<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // プロキシ指定があれば、以降に作られる HttpClient すべてに効かせるため
      // 通信が始まる前に差し込む。指定がなければ何もしない。
      DebugProxy.install();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // 扱われなかった Error や例外はバグなので、Crashlytics でクラッシュとして集計
      // する。ただし画像の読み込み失敗（通信できない・経路上のフィルタに遮断される
      // など）はバグではないので、これまでどおり非重大として記録する。画像が出ない
      // 問い合わせは、非重大に残るこの記録で原因を調べる。
      FlutterError.onError = (details) {
        if (details.library == 'image resource service') {
          FirebaseCrashlytics.instance.recordFlutterError(details);
        } else {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        }
      };

      final streamSharedPreference = await StreamingSharedPreferences.instance;
      final packageInfo = await PackageInfo.fromPlatform();

      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      FirebaseAnalytics.instance.setUserId(id: currentUser!.uid);
      FirebaseCrashlytics.instance.setUserIdentifier(currentUser.uid);

      final remoteConfig = FirebaseRemoteConfig.instance;
      if (const String.fromEnvironment('flavor') == 'development') {
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 0),
        ));
      }
      await remoteConfig.fetchAndActivate();

      runApp(
        ProviderScope(
          observers: [UncaughtErrorObserver()],
          overrides: [
            sharedPreferencesProvider.overrideWithValue(
              streamSharedPreference,
            ),
            packageInfoProvider.overrideWithValue(
              packageInfo,
            ),
            // domain が宣言した Repository / ErrorReporter / NavigationService を
            // data と app の実装に差し替える。
            ...dataProviderOverrides,
            ...appProviderOverrides,
          ],
          child: const App(),
        ),
      );
    },
    (error, stack) {
      // Firebase の初期化前に例外が起きると FirebaseCrashlytics.instance への
      // アクセス自体が [core/no-app] を投げ、元の例外が失われてしまう。
      // まずログへ出し、記録の失敗が元の例外を覆い隠さないようにする。
      debugPrint('Uncaught zone error: $error');
      debugPrintStack(stackTrace: stack);
      try {
        FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          fatal: true,
        );
      } catch (e) {
        debugPrint('Crashlytics へ記録できませんでした: $e');
      }
    },
  );
}
