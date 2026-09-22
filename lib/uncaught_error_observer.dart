import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// provider の生成中の例外は Riverpod が受け止めるので、Zone の未捕捉エラーに
/// 届かない。ここで拾ってクラッシュとして記録する。
class UncaughtErrorObserver extends ProviderObserver {
  UncaughtErrorObserver(this._crashlytics);

  final CrashlyticsDataSource _crashlytics;

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
    _crashlytics.recordFatal(
      error,
      stackTrace,
      reason: '${provider.name ?? provider.runtimeType} の生成中',
    );
  }
}
