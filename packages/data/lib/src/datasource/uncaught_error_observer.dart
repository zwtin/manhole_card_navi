import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:domain/domain.dart';

/// provider の生成中の例外は Riverpod が受け止めるので、Zone の未捕捉エラーに
/// 届かない。ここで拾ってクラッシュとして記録する。
class UncaughtErrorObserver extends ProviderObserver {
  UncaughtErrorObserver({FirebaseCrashlytics? crashlytics})
      : _crashlytics = crashlytics;

  final FirebaseCrashlytics? _crashlytics;

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    // data が返したときに記録済み。
    if (error is DomainException) {
      return;
    }
    unawaited(
      (_crashlytics ?? FirebaseCrashlytics.instance)
          .recordError(
            error,
            stackTrace,
            reason: '${provider.name ?? provider.runtimeType} の生成中',
            fatal: true,
          )
          .onError((_, __) {}),
    );
  }
}
