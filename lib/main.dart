import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'app.dart';
import 'flavors.dart';
import 'temporary_provider.dart';

FutureOr<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      // The following lines are the same as previously explained in "Handling uncaught errors"
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      final streamSharedPreference = await StreamingSharedPreferences.instance;
      final packageInfo = await PackageInfo.fromPlatform();
      final appDirectory = await getApplicationDocumentsDirectory();

      final remoteConfig = FirebaseRemoteConfig.instance;
      if (F.appFlavor == Flavor.development) {
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 0),
        ));
      }
      await remoteConfig.fetchAndActivate();

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(
              streamSharedPreference,
            ),
            packageInfoProvider.overrideWithValue(
              packageInfo,
            ),
            directoryProvider.overrideWithValue(
              appDirectory,
            ),
          ],
          child: App(
            key: UniqueKey(),
          ),
        ),
      );
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
      );
    },
  );
}
