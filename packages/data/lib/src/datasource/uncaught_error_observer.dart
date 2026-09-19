import 'dart:async';

import 'package:domain/domain.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// provider の中で扱われなかった例外や Error（バグ）を、Crashlytics にクラッシュ
/// （fatal）として記録する。main.dart の ProviderScope に渡す。
///
/// provider の生成中に投げられた例外は Riverpod が受け止めて AsyncError などに
/// するため、Zone の未捕捉エラーとしては届かない。ここで拾わないと、画面が
/// 表示されないだけでどこにも記録されずに消える。
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
    // DomainException は data が返した失敗を ViewModel が知らせてから投げるもので、
    // 調べる必要のあるものは data が返すときに記録済み。
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
