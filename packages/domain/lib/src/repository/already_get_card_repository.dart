import 'package:riverpod/riverpod.dart';

import '../core/result.dart';

/// アプリ全体で 1 つ。アプリのルート（lib/di/）で data パッケージの実装に差し替える。
final alreadyGetCardRepositoryProvider =
    Provider<AlreadyGetCardRepository>(
      (ref) =>
          throw UnimplementedError(
            'alreadyGetCardRepositoryProvider must be overridden',
          ),
    );

/// どのカードを取得したかの記録。記録しているのはカードの ID そのもの。
abstract class AlreadyGetCardRepository {
  /// 取得済みカードの ID。
  Future<Result<Set<String>>> get();

  /// 取得済みカードが変わるたびに流れる。購読を始めたときにも今の値が流れる。
  Stream<Set<String>> getStream();

  /// [cardId] のカードを取得済みにする。
  Future<Result<void>> save({required String cardId});

  /// [cardId] のカードを未取得に戻す。
  Future<Result<void>> delete({required String cardId});
}
