import 'package:riverpod/riverpod.dart';

import '../core/result.dart';

/// main.dart の ProviderScope で data パッケージの実装に差し替える。
final alreadyGetCardQueryServiceProvider =
    Provider.autoDispose<AlreadyGetCardQueryService>(
  (ref) => throw UnimplementedError(
    'alreadyGetCardQueryServiceProvider must be overridden',
  ),
);

/// 取得済みカードの ID を読む。
abstract class AlreadyGetCardQueryService {
  Future<Result<Set<String>>> get();

  /// 取得済みカードが変わるたびに流れる。購読を始めたときにも今の値が流れる。
  Stream<Set<String>> getStream();
}
