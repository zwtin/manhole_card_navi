import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'app.dart';

FutureOr<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      // The following lines are the same as previously explained in "Handling uncaught errors"
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      runApp(
        const App(),
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
