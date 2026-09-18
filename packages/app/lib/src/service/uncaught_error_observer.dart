import 'dart:async';

import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// provider の中で扱われなかった例外や Error（バグ）を [ErrorReporter] で記録する。
/// main.dart の ProviderScope に渡す。
///
/// provider の生成中に投げられた例外は Riverpod が受け止めて AsyncError などに
/// するため、Zone の未捕捉エラーとしては届かない。ここで拾わないと、画面が
/// 表示されないだけでどこにも記録されずに消える。
class UncaughtErrorObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    // DomainException は ViewModel が showFailure で知らせてから投げるもので、
    // そこで記録済み。
    if (error is DomainException) {
      return;
    }
    unawaited(
      container.read(errorReporterProvider).recordUncaught(
            error,
            stackTrace,
            reason: '${provider.name ?? provider.runtimeType} の生成中',
          ),
    );
  }
}
