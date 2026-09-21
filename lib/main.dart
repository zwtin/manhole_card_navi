import 'dart:async';
import 'dart:ui';

import 'package:app/app.dart';
import 'package:data/data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'debug_proxy.dart';
import 'di/infrastructure.dart';
import 'di/repository_overrides.dart';
import 'firebase_options.dart';
import 'uncaught_error_observer.dart';

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
      final crashlytics = CrashlyticsDataSource(FirebaseCrashlytics.instance);

      // 誰も扱わなかったものはバグなので、クラッシュとして記録する。画像の読み込み
      // 失敗だけは、data が取得に失敗した時点で記録済みなので二重に記録しない。
      FlutterError.onError = (details) {
        if (details.library == 'image resource service') {
          return;
        }
        crashlytics.recordFlutter(details);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.recordFatal(error, stack);
        return true;
      };

      final infrastructure = await Infrastructure.initialize();
      runApp(
        ProviderScope(
          observers: [UncaughtErrorObserver(infrastructure.crashlytics)],
          overrides: repositoryOverrides(infrastructure),
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
        CrashlyticsDataSource(FirebaseCrashlytics.instance)
            .recordFatal(error, stack);
      } catch (e) {
        debugPrint('Crashlytics へ記録できませんでした: $e');
      }
    },
  );
}
